//
//  HasEventHandler.swift
//  HitTest
//
//  Created by Dan Galbraith on 1/8/23.
//

import Foundation
import AppKit

public struct EventEnvironment {
     let view: RepresentedARView
}

public protocol EventHandler {
    func beginEventHandling(with event: NSEvent) -> EventHandler?
    func handleEvent(_ event: NSEvent) -> EventHandler?
    func endEventHandling(with event:NSEvent?)
    func abortEventHandling()
}

public protocol HasEventHandler {
    func handler(for event: NSEvent, in environment: EventEnvironment) -> EventHandler?
}
