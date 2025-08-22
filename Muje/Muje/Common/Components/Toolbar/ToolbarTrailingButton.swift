//
//  TopBarTrailingTextButton.swift
//  Muje
//
//  Created by 김진혁 on 8/20/25.
//

import SwiftUI

struct ToolbarTrailingButton: ToolbarContent {
    let toolbarType: ToolbarType
    var text: String?
    var action: (() -> Void)?
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Group {
                switch toolbarType {
                case .none:
                    EmptyView()
                case .text(let text):
                    Button(text) { action?() }
                case .image(let icon):
                    Button {
                        action?()
                    } label: {
                        iconView(icon)
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    private func iconView(_ icon: ToolbarImage) -> some View {
        switch icon {
        case .systemName(let name):
            Image(systemName: name)
                .toolbarImageButtonStyle()
        case .named(let name):
            Image(name)
                .toolbarImageButtonStyle()
        }
    }
}

#Preview {
    NavigationStack {
        Text("Preview")
            .toolbar {
                ToolbarTrailingButton(toolbarType: .image(.named("ellipsisVertical")))
            }
    }
}


