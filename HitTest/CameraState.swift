//
//  CameraState.swift
//  HitTest
//
//  Created by Dan Galbraith on 1/6/23.
//

import Foundation
import RealityKit

public protocol CameraStateProvider {
    func currentCameraState() -> CameraState
    func changeCameraState(to state: CameraState)
}

public struct CameraState: Codable {
    static var defaultCameraState = CameraState(cameraTarget: simd_float3(), inclinationInDegrees: -40.0, rotationAngleInDegrees: 0.0, radius: 5.0)
    
    var cameraTarget: simd_float3
    var inclinationAngleInRadians: Float
    var inclinationAngleInDegrees: Float {
        get { inclinationAngleInRadians * (180.0 / Float.pi) }
        set { inclinationAngleInRadians = newValue * (Float.pi / 180.0) }
    }
    
    var rotationAngleInRadians: Float
    var rotationAngleInDegrees: Float {
        get { rotationAngleInRadians * (180.0 / Float.pi) }
        set { rotationAngleInRadians = newValue * (Float.pi / 180.0) }
    }
    
    var radius: Float
    
    public init() {
        cameraTarget = simd_float3(0, 0, 0)
        inclinationAngleInRadians = 0.0
        rotationAngleInRadians = 0.0
        radius = 2.0
    }
    
    public init(
        cameraTarget: simd_float3 = simd_float3(0, 0, 0),
        inclinationInRadians: Float = 0,
        rotationAngleInRadians: Float = 0,
        radius: Float = 2
    ) {
        self.cameraTarget = cameraTarget
        inclinationAngleInRadians = inclinationInRadians
        self.rotationAngleInRadians = rotationAngleInRadians
        self.radius = radius
    }
    
    public init(
        cameraTarget: simd_float3 = simd_float3(0, 0, 0),
        inclinationInDegrees: Float = 0,
        rotationAngleInDegrees: Float = 0,
        radius: Float = 2
    ) {
        self.cameraTarget = cameraTarget
        inclinationAngleInRadians = inclinationInDegrees * (Float.pi / 180.0)
        rotationAngleInRadians = rotationAngleInDegrees * (Float.pi / 180.0)
        self.radius = radius
    }
    
    public func updateCamera(_ camera: PerspectiveCamera) {
        let data = String(format: "Moving camera to radius: % .3f, inclination: % .3f rotation: % .3f", radius, inclinationAngleInDegrees, rotationAngleInDegrees)
        print(data)
        let transform = Transform(matrix: cameraTransform())
        camera.transform = transform
        // This spins the camera AT its current location to look at a specific target location
        camera.look(at: self.cameraTarget, from: transform.translation, relativeTo: nil)
    }
    
    public func cameraTransform() -> simd_float4x4 {
        let translationTransform = Transform(scale: .one,
                                             rotation: simd_quatf(),
                                             translation: SIMD3<Float>(0, 0, self.radius))
        let combinedRotationTransform: Transform = .init(pitch: self.inclinationAngleInRadians, yaw: self.rotationAngleInRadians, roll: 0)
        
        // ORDER of operations is critical here to getting the correct transform:
        // - identity -> rotation -> translation
        let computed_transform = matrix_identity_float4x4 * combinedRotationTransform.matrix * translationTransform.matrix

        return computed_transform
    }
}


