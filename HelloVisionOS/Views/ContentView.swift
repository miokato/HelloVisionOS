//
//  ContentView.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI
import RealityKit


struct ContentView: View {
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(AppModel.self) private var appModel
    
    let rootEntity = Entity()
    
    private func onChangeImmersiveState() {
        guard appModel.immersiveSpaceState == .open else { return }
        dismissWindow()
    }

    var body: some View {
        VStack(spacing: 8) {
            Text("Hello, world!")
            ToggleImmersiveSpaceButton()
            HStack(spacing: 8) {
                Button("One") {
                    openWindow(id: Constants.volumetricWindowID)
                    
                }
            }
        }
        .onChange(of: appModel.immersiveSpaceState, onChangeImmersiveState)
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
