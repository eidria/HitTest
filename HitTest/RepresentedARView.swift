//
//  CameraControlARView.swift
//
//
//  Created by Joseph Heck on 2/7/22.
//

import Cocoa
import RealityKit
//import ViewRepresentation

public typealias ARViewRepresentationCoordinator = Coordinator<RepresentedARView>
public typealias ARViewRepresentation = ViewRepresentation<RepresentedARView>

public protocol ARViewEventDelegate: AnyObject {
    func handleKeyDown(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleKeyUp(_ event: NSEvent, inARView arView: RepresentedARView)

    func handleMouseMoved(_ event: NSEvent, inARView arView: RepresentedARView)

    func handleMouseDown(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleMouseDragged(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleMouseUp(_ event: NSEvent, inARView arView: RepresentedARView)

    func handleRightMouseDown(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleRightMouseDragged(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleRightMouseUp(_ event: NSEvent, inARView arView: RepresentedARView)

    func handleOtherMouseDown(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleOtherMouseDragged(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleOtherMouseUp(_ event: NSEvent, inARView arView: RepresentedARView)

    func handleScrollWheel(_ event: NSEvent, inARView arView: RepresentedARView)
    func handleMagnify(_ event: NSEvent, inARView arView: RepresentedARView)
}

@objc public class RepresentedARView: ARView {
    /// Weak reference to delegate to prevent retain cycles
    public weak var eventDelegate: ARViewEventDelegate?

    public init() {
        super.init(frame: .zero)
    }
    
    /// - Parameter frameRect: The frame rectangle for the view, measured in points.
    public required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    @available(*, unavailable)
    @MainActor dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isFlipped: Bool { true }

    override public func keyDown(with event: NSEvent) {
        eventDelegate?.handleKeyDown(event, inARView: self)
    }

    override public func keyUp(with event: NSEvent) {
        eventDelegate?.handleKeyUp(event, inARView: self)
    }

    override public func mouseDown(with event: NSEvent) {
        eventDelegate?.handleMouseDown(event, inARView: self)
    }

    override public func mouseDragged(with event: NSEvent) {
        eventDelegate?.handleMouseDragged(event, inARView: self)
    }

    override public func mouseUp(with event: NSEvent) {
        eventDelegate?.handleMouseUp(event, inARView: self)
    }

    override public func rightMouseDown(with event: NSEvent) {
        eventDelegate?.handleRightMouseDown(event, inARView: self)
    }

    override public func rightMouseDragged(with event: NSEvent) {
        eventDelegate?.handleRightMouseDragged(event, inARView: self)
    }

    override public func rightMouseUp(with event: NSEvent) {
        eventDelegate?.handleRightMouseUp(event, inARView: self)
    }

    override public func otherMouseDown(with event: NSEvent) {
        eventDelegate?.handleRightMouseDown(event, inARView: self)
    }

    override public func otherMouseDragged(with event: NSEvent) {
        eventDelegate?.handleRightMouseDragged(event, inARView: self)
    }

    override public func otherMouseUp(with event: NSEvent) {
        eventDelegate?.handleRightMouseUp(event, inARView: self)
    }

    override public func scrollWheel(with event: NSEvent) {
        eventDelegate?.handleScrollWheel(event, inARView: self)
    }

    override public func magnify(with event: NSEvent) {
        eventDelegate?.handleMagnify(event, inARView: self)
    }
}
