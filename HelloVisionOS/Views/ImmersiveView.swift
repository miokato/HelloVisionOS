//
//  ImmersiveView.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            let material = SimpleMaterial(color: .red, isMetallic: false)
            let box = ModelEntity(
                mesh: .generateBox(size: 0.3),
                materials: [material]
            )
            box.position = .init(x: -0.5, y: 2.5, z: -2.0)
            box.generateCollisionShapes(recursive: false)
            box.components[InputTargetComponent.self] = InputTargetComponent(
                allowedInputTypes: .all
            )
            
            content.add(box)
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
