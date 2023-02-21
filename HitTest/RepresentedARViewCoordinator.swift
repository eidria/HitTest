//
//  RepresentedARViewCoordinator.swift
//  HitTest
//
//  Created by Dan Galbraith on 12/17/22.
//

import Combine
import Foundation
import RealityKit
import SwiftUI
//import ViewRepresentation

/// The coordinator object that facilitates to and from the wrapped view.
public class RepresentedARViewCoordinator: ARViewRepresentationCoordinator {
    var cameraState: CameraState
        
    private let arViewAnchor: ARViewAnchor = ARViewAnchor()
    private let eventHandler: ARViewEventHandler
    private var cancellables = Set<AnyCancellable>()

    public override init() {
        cameraState = CameraState.defaultCameraState
        eventHandler = ARViewEventHandler(arViewAnchor: arViewAnchor, cameraStateSource: arViewAnchor)
        super.init()
    }

    override public func configureView(_ view: RepresentedARView, transaction: Transaction, environment: EnvironmentValues) {
        view.scene.addAnchor(arViewAnchor)
        view.eventDelegate = eventHandler
        view.environment.background = ARView.Environment.Background.color(NSColor.black)
        view.debugOptions = .showPhysics

        arViewAnchor.cameraState = cameraState
     }

    override public func updateView(_ view: RepresentedARView, transaction: Transaction, environment: EnvironmentValues) {
    }

    override public func dismantleView(_ view: RepresentedARView) {
        arViewAnchor.removeFromParent()
    }

    public func handleHoverPhaseChange(phase: HoverPhase, view: RepresentedARView) {
        var collisions: [CollisionCastHit] = []
         switch phase {
        case let .active(viewPoint):
            collisions = view.hitTest(viewPoint, query: .nearest)
        case .ended: ()
        }

        arViewAnchor.handleHoverResults(collisions: collisions)
    }
}
