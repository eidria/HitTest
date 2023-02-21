//
//  BoxView.swift
//  HitTest
//
//  Created by Dan Galbraith on 1/30/23.
//

import SwiftUI

struct BoxView: View {
    @State private var viewCoordinator = RepresentedARViewCoordinator()
    @State private var arView = RepresentedARView()
    
    var body: some View {
        ARViewRepresentation(
            coordinatorFactory: viewCoordinatorFactory,
            viewFactory: viewFactory
        )
        .onContinuousHover { phase in
             viewCoordinator.handleHoverPhaseChange(phase: phase, view: arView)
        }
    }
    
    func viewCoordinatorFactory() -> ARViewRepresentationCoordinator {
        viewCoordinator
    }
    
    func viewFactory() -> RepresentedARView {
        arView
    }
}
