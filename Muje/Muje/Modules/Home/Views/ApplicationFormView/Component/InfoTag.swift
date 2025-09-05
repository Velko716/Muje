//
//  InfoTag.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import SwiftUI

struct InfoTag: View {
    let title: String
    let isActive: Bool
    
    var body: some View {
        Text(title)
            .caption14Medium()
            .foregroundStyle(isActive ? .pointSkyBlue : .gray500)
            .padding(.vertical, 6.5)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(
                    cornerRadius: 100
                )
                .stroke(
                    isActive ? Color.pointSkyBlue : Color.gray200,
                    lineWidth: 1
                )
                .fill(isActive ? .pointSkyBlueTinted : .clear)
            )
    }
}

#Preview {
    InfoTag(title: "학과 / 전공", isActive: true)
}
