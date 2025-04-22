//
//  SpatialAudioView.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI
import RealityKit

struct SpatialAudioView: View {
    let entity = EntityProvider.roundedBoxEntity
    var body: some View {
        HStack {
            Text("Hello World")
                .font(.largeTitle)
                .padding(.leading, 20)
            Text("Hello World")
                .font(.largeTitle)
                .padding(.leading, 20)
            RealityView { content in
                content.add(entity)

                let audioName: String = "FunkySynth.m4a"
                let configuration = AudioFileResource.Configuration(shouldLoop: true)
                guard let audio = try? AudioFileResource.load(
                    named: audioName,
                    configuration: configuration
                ) else {
                    print("Failed to load audio file.")
                    return
                }
                let focus: Double = 0.5
                entity.spatialAudio = SpatialAudioComponent(
                    directivity: .beam(focus: focus)
                )
                entity.playAudio(audio)
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    SpatialAudioView()
}
