//
//  ARViewEventHandler.swift
//  HitTest
//
//  Created by Dan Galbraith on 1/6/23.
//

import AppKit
import Foundation
import RealityKit

class ARViewEventHandler: ARViewEventDelegate {
    private var arViewAnchor: ARViewAnchor
    private var currentEventHandler: EventHandler?
    private var cameraStateSource: CameraStateProvider
    
    init(arViewAnchor: ARViewAnchor, cameraStateSource: CameraStateProvider) {
        self.arViewAnchor = arViewAnchor
        self.cameraStateSource = cameraStateSource
    }

    public func handleScrollWheel(_ event: NSEvent, inARView arView: RepresentedARView) {
        //        if currentMouseHandler == nil {
        //            var newCameraState = cameraController.cameraState
        //            let multiplier = Float(event.scrollingDeltaY) / 10.0 // magnify_end
        //            newCameraState.radius = newCameraState.radius * (multiplier + 1)
        //            cameraController.cameraState = newCameraState
        //        }
    }

    public func handleMouseDown(_ event: NSEvent, inARView arView: RepresentedARView) {
        currentEventHandler = findMouseEventHandler(for: event, in: arView)
        currentEventHandler = currentEventHandler?.beginEventHandling(with: event)
    }

    public func handleMouseDragged(_ event: NSEvent, inARView arView: RepresentedARView) {
        currentEventHandler = currentEventHandler?.handleEvent(event)
    }

    public func handleMouseUp(_ event: NSEvent, inARView arView: RepresentedARView) {
        currentEventHandler?.endEventHandling(with: event)
        currentEventHandler = nil
    }

    public func handleMagnify(_ event: NSEvent, inARView arView: RepresentedARView) {
        var newCameraState = cameraStateSource.currentCameraState()
        let multiplier = Float(event.magnification) // magnify_end
        newCameraState.radius = newCameraState.radius * (multiplier + 1)
        cameraStateSource.changeCameraState(to: newCameraState)
    }

    public func findMouseEventHandler(for event: NSEvent, in view: RepresentedARView) -> EventHandler? {
        return CameraController(cameraStateProvider: cameraStateSource, camera: arViewAnchor.camera)
    }
}

// Stash for handlers of as-yet-unhandled events
extension ARViewEventHandler {
    func handleKeyDown(_ event: NSEvent, inARView arView: RepresentedARView) { }

    func handleKeyUp(_ event: NSEvent, inARView arView: RepresentedARView) { }

    func handleMouseMoved(_ event: NSEvent, inARView arView: RepresentedARView) {
        print("handleMouseMoved, event type: \(event.type)")
    }

    func handleRightMouseDown(_ event: NSEvent, inARView arView: RepresentedARView) { }

    func handleRightMouseDragged(_ event: NSEvent, inARView arView: RepresentedARView) { }

    func handleRightMouseUp(_ event: NSEvent, inARView arView: RepresentedARView) { }

    func handleOtherMouseDown(_ event: NSEvent, inARView arView: RepresentedARView) { }

    func handleOtherMouseDragged(_ event: NSEvent, inARView arView: RepresentedARView) { }

    func handleOtherMouseUp(_ event: NSEvent, inARView arView: RepresentedARView) { }
}
