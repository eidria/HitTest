//
//  ARViewAnchor.swift
//  HitTest
//
//  Created by Dan Galbraith on 1/4/23.
//

import AppKit
import Combine
import Foundation
import GridEntity
import RealityKit

public class ARViewAnchor: Entity, HasAnchoring, CameraStateProvider {
    var boxEntity = ModelEntity()
    var camera = PerspectiveCamera()

    public var cameraState = CameraState.defaultCameraState {
        didSet {
            cameraState.updateCamera(camera)
        }
    }

    public func currentCameraState() -> CameraState {
        cameraState
    }

    public func changeCameraState(to state: CameraState) {
        cameraState = state
    }

    public required init() {
        super.init()

        setupBox()
        
        camera.camera.near = 0.001
        camera.camera.far = 50.0

        addChild(boxEntity)
        addChild(camera)
    }
    
    public func setupBox() {
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(tint: NSColor.lightGray)
        material.blending = .init(blending: .transparent(opacity: 0.3))
        let mesh = MeshResource.generateBox(size: 2.0)
        boxEntity.model = .init(mesh: mesh, materials: [material])
        boxEntity.generateCollisionShapes(recursive: false)
    }
    
    public func handleHoverResults(collisions: [CollisionCastHit]) {
        let date = Date.now.formatted(date: .omitted, time: .standard)
        let prefix = "\(date) "
        let suffix = ", camera: \(camera.position.string)"
        
        collisions.dumpToConsole(prefix: prefix, suffix: suffix)
    }
}

