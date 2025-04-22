//
//  ToggleImmersiveSpaceButton.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI

struct ToggleImmersiveSpaceButton: View {
    
    @Environment(AppModel.self) private var appModel
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    // MARK: - methods
    
    /// IDを指定してImmersive spaceを開く
    private func openImmersiveSpace() async {
        switch await openImmersiveSpace(id: Constants.draggableBoxID) {
        case .opened:
            log("Already opened")
            // ImmersiveView.onAppear() に複数のパスがある可能性があるため、
            // immersiveSpaceState を .open に設定するのは ImmersiveView.onAppear() 内だけ にしてください。
            // それ以外の場所では .open を設定しないようにしましょう。
            break
        case .userCancelled, .error:
            log("UserCancelled or error")
            // エラーが発生した場合は、イマーシブスペースのオープンに失敗したことを示すために、immersiveSpaceState を .closed に設定する必要があります。
            fallthrough
        @unknown default:
            // 不明なレスポンスを受け取った場合は、スペースが開かなかったと見なして、immersiveSpaceState を .closed に設定してください。
            appModel.immersiveSpaceState = .closed
        }
    }
    
    /// Appの状態に応じてImmersiveSpaceの開閉をハンドリング
    private func handleImmersiveSpace() {
        Task {
            switch appModel.immersiveSpaceState {
            case .open:
                log("To close immersive space")
                appModel.immersiveSpaceState = .inTransition
                await dismissImmersiveSpace()
                // ImmersiveView.onDisappear() には複数のパスが存在するため、
                // immersiveSpaceState を .closed に設定するのは ImmersiveView.onDisappear() 内だけ にしてください。
                // それ以外の場所で .closed を設定しないようにしましょう。
                
            case .closed:
                appModel.immersiveSpaceState = .inTransition
                await openImmersiveSpace()
                
            case .inTransition:
                log("inTransition")
                // このケースは発生しないはずです。なぜなら、このケースではボタンが無効化されているからです。
                break
            }
        }
    }
    
    // MARK: - body
    
    var body: some View {
        Button {
            handleImmersiveSpace()
        } label: {
            Text(appModel.immersiveSpaceState == .open ? "Hide Immersive Space" : "Show Immersive Space")
        }
        .disabled(appModel.immersiveSpaceState == .inTransition)
        .animation(.none, value: 0)
        .fontWeight(.semibold)
    }
}
