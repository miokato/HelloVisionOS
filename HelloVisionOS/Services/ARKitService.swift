//
//  ARKitService.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/24.
//

import ARKit
import RealityKit

@MainActor
final class ARKitService {
    private var session = ARKitSession()
    private var planeProvider: PlaneDetectionProvider?
    public var planeEntities: [UUID: Entity] = [:]
    
    // MARK: - ARKit セッション開始
    public func startPlaneDetection() async throws {
        // Provider を生成して希望のアラインメントを指定（水平のみ）
        let provider = PlaneDetectionProvider(alignments: [.horizontal])
        planeProvider = provider
        
        // セッション開始
        try await session.run([provider])
        
        // アンカー更新ストリームを監視
        for await update in provider.anchorUpdates {
            switch update.event {
            case .added, .updated:
                let anchor = update.anchor
                log("\(anchor)")
                // 透明エンティティを生成または更新
                if let entity = planeEntities[anchor.id] {
                    entity.setTransformMatrix(anchor.originFromAnchorTransform, relativeTo: nil)
                } else {
                    let entity = makeTransparentPlane(for: anchor)
                    log("\(entity)", with: .debug)
                    planeEntities[anchor.id] = entity
                }
            case .removed:
                // 平面が消えたら Entity も破棄
                if let entity = planeEntities.removeValue(forKey: update.anchor.id) {
                    entity.removeFromParent()
                }
            }
        }
    }
    
    // MARK: - 透明な平面エンティティ
    public func makeTransparentPlane(for anchor: PlaneAnchor) -> Entity {
        // Anchor と同サイズの平面メッシュを生成
        let size = SIMD3(anchor.geometry.extent.width, 0.002, anchor.geometry.extent.height)        // 非ゼロ厚でコライダ確保
        let mesh = MeshResource.generateBox(size: size, cornerRadius: 0)
        var material = SimpleMaterial()
        material.color = .init(tint: .white.withAlphaComponent(0.1))       // ほぼ透明
        let plane = ModelEntity(mesh: mesh, materials: [material])
        
        // 衝突判定と入力ターゲットを追加（ジェスチャ用）
        plane.generateCollisionShapes(recursive: true)
        plane.components.set(InputTargetComponent())
        
        // Anchor の座標に合わせる
        plane.transform.matrix = anchor.originFromAnchorTransform
        return plane
    }
}
