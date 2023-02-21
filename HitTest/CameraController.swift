//
//  CameraController.swift
//  HitTest
//
//  Created by Dan Galbraith on 1/9/23.
//

import AppKit
import Combine
import Foundation
import RealityKit

public class CameraController: EventHandler {
    private var mouseDownLocation = NSPoint()
    private var initialCameraState: CameraState
    private let camera: PerspectiveCamera
    public let cameraStateProvider: CameraStateProvider

    public init(cameraStateProvider: CameraStateProvider, camera: PerspectiveCamera) {
        self.cameraStateProvider = cameraStateProvider
        self.camera = camera
        initialCameraState = cameraStateProvider.currentCameraState()
    }

    public func beginEventHandling(with event: NSEvent) -> EventHandler? {
        mouseDownLocation = event.locationInWindow
        return self
    }

    public func handleEvent(_ event: NSEvent) -> EventHandler? {
        newCameraState(using: event).updateCamera(camera)
        return self
    }

    public func endEventHandling(with event: NSEvent?) {
        guard let event else { return }

        let finalCameraState = newCameraState(using: event)
        finalCameraState.updateCamera(camera)
        cameraStateProvider.changeCameraState(to: finalCameraState)
    }

    public func abortEventHandling() {
        initialCameraState.updateCamera(camera)
    }

    private func newCameraState(using event: NSEvent) -> CameraState {
        var newCameraState = initialCameraState

        let deltaX = Float(event.locationInWindow.x - mouseDownLocation.x)
        let deltaY = Float(event.locationInWindow.y - mouseDownLocation.y)
        let dragspeed: Float = 0.01

        newCameraState.rotationAngleInRadians = initialCameraState.rotationAngleInRadians - deltaX * dragspeed
        newCameraState.inclinationAngleInRadians = initialCameraState.inclinationAngleInRadians + deltaY * dragspeed

        if newCameraState.inclinationAngleInRadians > Float.pi / 2 {
            newCameraState.inclinationAngleInRadians = Float.pi / 2
        }

        if newCameraState.inclinationAngleInRadians < -Float.pi / 2 {
            newCameraState.inclinationAngleInRadians = -Float.pi / 2
        }

        return newCameraState
    }
}
