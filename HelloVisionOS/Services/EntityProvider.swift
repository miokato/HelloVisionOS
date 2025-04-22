//
//  EntityProvider.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

@preconcurrency import RealityKit

@MainActor
enum EntityProvider {
    static let whiteMaterial = SimpleMaterial(color: .white, isMetallic: false)
    
    static let roundedBoxEntity: Entity = {
        // Create a new entity instance.
        let entity = Entity()

        // Create a new mesh resource.
        let boxSize: Float = 0.1
        let boxCornerRadius: Float = 0.03
        let roundedBoxMesh = MeshResource.generateBox(size: boxSize, cornerRadius: boxCornerRadius)

        // Add the mesh resource to a model component, and add it to the entity.
        entity.components.set(ModelComponent(mesh: roundedBoxMesh, materials: [whiteMaterial]))

        return entity
    }()
    
    static func createBox() -> ModelEntity {
        let material = SimpleMaterial(color: .red, isMetallic: false)
        let box = ModelEntity(
            mesh: .generateBox(size: 0.3),
            materials: [material]
        )
        box.generateCollisionShapes(recursive: false)
        box.components[InputTargetComponent.self] = InputTargetComponent(
            allowedInputTypes: .all
        )
        return box
    }
    
    static let coneEntity: Entity = {
        // Create a new entity instance.
        let entity = Entity()
        
        // Create a new mesh resource.
        let coneHeight: Float = 0.1
        let coneRadius: Float = 0.05
        let roundedBoxMesh = MeshResource.generateCone(height: coneHeight, radius: coneRadius)
        
        // Add the mesh resource to a model component, and add it to the entity.
        entity.components.set(ModelComponent(mesh: roundedBoxMesh, materials: [whiteMaterial]))
        
        return entity
    }()
}

