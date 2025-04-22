//
//  BoxView.swift
//  HelloVisionOS
//
//  Created by mio kato on 2025/04/20.
//

import SwiftUI
import RealityKit

struct BoxView: View {
    var body: some View {
        RealityView { content in
            content.add(EntityProvider.roundedBoxEntity)
        }
    }
}

#Preview(windowStyle: .automatic) {
    BoxView()
}
