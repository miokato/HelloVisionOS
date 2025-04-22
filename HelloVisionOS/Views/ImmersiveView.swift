//
//  ImmersiveView.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    let rootEntity = Entity()
    let objectEntity = Entity()
    
    @State private var boxEntity: ModelEntity?
    @State private var initialPosition: SIMD3<Float>? = nil
    @State private var initialScale: SIMD3<Float>? = nil
    @State private var initialTransform: Transform?
    
    /// スケールとY軸回転のジェスチャー
    private var combindGesture: some Gesture {
        translationGesture
            .simultaneously(with: scaleGesture)
            .simultaneously(with: rotationGesture)
    }

    /// 移動ジェスチャー
    private var translationGesture: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged({ value in
                let entity = value.entity
                if initialPosition == nil {
                    initialPosition = entity.position
                }
                let movement = value.convert(
                    value.translation3D,
                    from: .global,
                    to: .scene
                )
                entity.position = (initialPosition ?? .zero) + movement
            })
            .onEnded({ _ in
                initialPosition = nil
            })
    }
    
    /// 拡大縮小ジェスチャー
    private var scaleGesture: some Gesture {
        MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if initialScale == nil {
                    initialScale = entity.scale
                }
                let scaleRate: Float = 1.0
                entity.scale = (initialScale ?? .init(repeating: scaleRate)) * Float(value.gestureValue.magnification)
            }
            .onEnded { _ in
                initialScale = nil
            }
    }
    
    /// Y軸回転のジェスチャー
    private var rotationGesture: some Gesture {
        RotationGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = value.entity
                if initialTransform == nil {
                    initialTransform = entity.transform
                }
                let delta = Float(value.gestureValue.radians)
                var t = initialTransform!
                let q = simd_quatf(angle: delta, axis: [0, 1, 0])
                t.rotation = q * t.rotation
                entity.transform = t
            }
            .onEnded { _ in
                initialTransform = nil
            }
    }
    
    // MARK: - body
    
    var body: some View {
        ZStack {
            RealityView { content, attachments in
                boxEntity = EntityProvider.createBox()
                objectEntity.addChild(boxEntity!)
                objectEntity.position = .init(x: 0, y: 1.5, z: -1.0)
                rootEntity.addChild(objectEntity)
                
                content.add(rootEntity)
                if let panelAttachment = attachments.entity(for: "panel") {
                    content.add(panelAttachment)
                }
            } update: { content, attachments in
                if let text = attachments.entity(for: "panel") {
                    text.position = objectEntity.position + [0, 0.2, 0]
                }
            } attachments: {
                Attachment(id: "panel") {
                    HStack {
                        Button("HELLO") {
                            print("HELLO")
                        }
                        Button("WORLD") {
                            print("WORLD")
                        }
                    }
                }
                
            }
            .gesture(combindGesture)
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
