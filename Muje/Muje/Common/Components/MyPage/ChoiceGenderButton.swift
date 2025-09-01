//
//  ChoiceGenderButton.swift
//  Muje
//
//  Created by 김진혁 on 9/2/25.
//

import SwiftUI

struct ChoiceGenderButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.blue) // FIXME: - 컬러 수정
                .frame(maxWidth: .infinity)
                .overlay {
                    Text(title)
                        .font(Font.system(size: 18, weight: .semibold)) // FIXME: - 폰트 수정
                        .foregroundStyle(Color.black) // FIXME: - 컬러 수정
                }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HStack(spacing: 17) {
        ChoiceGenderButton(title: "남") {}
        ChoiceGenderButton(title: "여") {}
    }
    .frame(height: 56)
    .padding(.horizontal, 16)
}
