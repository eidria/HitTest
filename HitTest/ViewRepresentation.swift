import SwiftUI

#if os(macOS)
    import AppKit
    public typealias BaseViewType = NSView
    @available(macOS 10.15, *)
    public typealias BaseRepresentableType = NSViewRepresentable
#elseif os(iOS)
    import UIKit
    public typealias BaseViewType = UIView
    @available(iOS 13.0, *)
    public typealias BaseRepresentableType = UIViewRepresentable
#endif

@available(iOS 13.0, *)
@available(macOS 10.15, *)
open class Coordinator<ViewType: BaseViewType> {
    public init() {}
    open func configureView(_ view: ViewType, transaction: Transaction, environment: EnvironmentValues) {}
    open func updateView(_ view: ViewType, transaction: Transaction, environment: EnvironmentValues) {}
    open func dismantleView(_ view: ViewType) {}
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public struct ViewRepresentation<ViewType: BaseViewType>: BaseRepresentableType {
    public typealias CoordinatorFactory = () -> Coordinator<ViewType>
    public typealias ViewFactory = () -> ViewType

    var coordinatorFactory: CoordinatorFactory
    var viewFactory: ViewFactory

    public init(
        coordinatorFactory: @escaping CoordinatorFactory,
        viewFactory: @escaping ViewFactory
    ) {
        self.coordinatorFactory = coordinatorFactory
        self.viewFactory = viewFactory
    }

    /// Creates a coordinator to establish the view and to pass updates to and from the SwiftUI context hosting the view.
    /// Required method of NSViewRepresentable/UIViewRepresentable
    public func makeCoordinator() -> Coordinator<ViewType> {
        coordinatorFactory()
    }

    #if os(macOS)
        /// Creates a new wrapped  view.
        /// Required method of NSViewRepresentable
        public func makeNSView(context: Context) -> ViewType {
            let view = viewFactory()
            context.coordinator.configureView(
                view,
                transaction: context.transaction,
                environment: context.environment
            )
            return view
        }

        /// Updates the wrapped  view with state information from SwiftUI.
        /// Required method of NSViewRepresentable
        public func updateNSView(_ view: ViewType, context: Context) {
            context.coordinator.updateView(
                view,
                transaction: context.transaction,
                environment: context.environment
            )
        }

        public static func dismantleNSView(_ nsView: ViewType, coordinator: Coordinator<ViewType>) {
            coordinator.dismantleView(nsView)
        }

    #elseif os(iOS)
        /// Creates a new wrapped  view.
        /// Required method of UIViewRepresentable
        public func makeUIView(context: Context) -> ViewType {
            let view = viewFactory()
            context.coordinator.configureView(
                view,
                transaction: context.transaction,
                environment: context.environment
            )
            return view
        }

        /// Updates the wrapped  view with state information from SwiftUI.
        /// Required method of UIViewRepresentable
        public func updateUIView(_ view: ViewType, context: Context) {
            context.coordinator.updateView(
                view,
                transaction: context.transaction,
                environment: context.environment
            )
        }

        public static func dismantleUIView(_ uiView: ViewType, coordinator: Coordinator<ViewType>) {
            coordinator.dismantleView(uiView)
        }
    #endif
}
