//
//  GenderChoiceButton.swift
//  Muje
//
//  Created by 김진혁 on 9/2/25.
//

import SwiftUI

struct GenderChoiceButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue.opacity(0.2)) // FIXME: - 컬러 수정
                .frame(maxWidth: .infinity)
                .overlay {
                    Text(title)
                        .font(Font.system(size: 18, weight: .semibold)) // FIXME: - 폰트 수정
                        .foregroundStyle(isSelected ? Color.blue.opacity(0.6) : Color.black) // FIXME: - 컬러 수정
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : .clear, lineWidth: 1)
                )
        }
        .animation(.smooth(duration: 0.20), value: isSelected)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HStack(spacing: 17) {
        GenderChoiceButton(title: "남", isSelected: true) {}
        GenderChoiceButton(title: "여", isSelected: false) {}
    }
    .frame(height: 56)
    .padding(.horizontal, 16)
}
