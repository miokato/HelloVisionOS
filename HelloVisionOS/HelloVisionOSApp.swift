//
//  HelloVisionOSApp.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI

@main
struct HelloVisionOSApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup(id: appModel.windowSpaceID) {
            ContentView()
                .environment(appModel)
        }
        
        ImmersiveSpace(id: Constants.draggableBoxID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
