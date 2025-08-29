//
//  ActionRow.swift
//  Muje
//
//  Created by 김진혁 on 8/17/25.
//

import SwiftUI

struct ActionRow: View {
    let icon: String
    let title: String
    var titleColor: Color = .primary
    var iconTint: Color = .secondary
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(iconTint)

                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(titleColor)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    ActionRow(icon: "bell.badge", title: "차단하기") {
        print("차단하기")
    }
}
