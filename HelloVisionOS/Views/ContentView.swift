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
    
    let rootEntity = Entity()
    

    var body: some View {
        VStack(spacing: 8) {
            Text("Hello, world!")
            ToggleImmersiveSpaceButton()
            HStack(spacing: 8) {
                Button("One") {
                    openWindow(id: Constants.volumetricWindowID)
                    
                }
                Button("Two") {
                    
                }
                Button("Three") {
                    
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
