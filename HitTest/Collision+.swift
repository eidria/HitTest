//
//  Collision+.swift
//  HitTest
//
//  Created by Dan Galbraith on 2/15/23.
//

import Foundation
import RealityKit

extension SIMD3<Float> {
    var string:String { String(format: "(x: % .3f, y: % .3f, z: % .3f)", x, y, z) }
}

extension CollisionCastHit {
    func dumpToConsole(prefix: String, suffix: String) {
        let distanceString = String(format: "distance % .3f", distance)
        let data = "\(prefix)position: \(position.string), normal: \(normal.string) \(distanceString)\(suffix)"
        print(data)
    }
}

extension Array where Element == CollisionCastHit {
    func dumpToConsole(prefix: String, suffix: String) {
        for collision in self {
            collision.dumpToConsole(prefix: prefix, suffix: suffix)
        }
    }
}
