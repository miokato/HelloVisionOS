//
//  AppModel.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI

/// Maintains app-wide state
@MainActor
@Observable
class AppModel {
    let windowSpaceID = "WindowSpace"
    let immersiveSpaceID = "ImmersiveSpace"
    enum ImmersiveSpaceState {
        case closed
        case inTransition
        case open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed
}
