//
//  StatusCard.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct StatusCard: View {
    var title: String
    var color: Color
    
    var body: some View {
        Text(title)
            .foregroundStyle(color)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.3))
            )
    }
}

#Preview {
    StatusCard(title: "모집 중", color: Color.green)
}
