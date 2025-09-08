//
//  CustomInput.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct CustomInput: View {
    @FocusState private var isFocused: Bool
    var title: String
    var tempTitle: String
    var textValue: Binding<String>
    var subTitle: String?
    let maxLength: Int
    let config = Font.lineHeight(
        type: .medium,
        fontSize: 16,
        lineHeightPercent: 1.85,
        letterSpacingPercent: -1
    )
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let sub = subTitle {
                HStack(alignment: .bottom, spacing: 8) {
                    Text(title)
                        .caption14SemiBold()
                        .foregroundStyle(.gray700)
                    Text(sub)
                        .caption14Regular()
                        .foregroundStyle(.gray500)
                }
            } else {
                Text(title)
                    .caption14SemiBold()
                    .foregroundStyle(.gray700)
            }
            TextField(tempTitle, text: textValue, axis: .vertical)
                .maxLength(text: textValue, maxLength)
                .focused($isFocused)
                .font(.pretendard(type: .medium, size: 16))
                .padding(.vertical, config.verticalPadding)
                .padding(16)
                .tracking(config.letterSpacing)
                .foregroundStyle(.gray700, .gray500)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .strokeBorder(isFocused ? .pointSkyBlue : .gray100, lineWidth: 1)
                )
        }
    }
}
