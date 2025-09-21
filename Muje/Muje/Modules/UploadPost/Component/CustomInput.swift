//
//  CustomInput.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct CustomInput: View {
    @FocusState private var isFocused: Bool
    @Binding var textLen: Int
    var title: String
    var tempTitle: String
    var textValue: Binding<String>
    var subTitle: String?
    let maxLength: Int
    let minLength: Int
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
                        .strokeBorder(borderStrokeColor, lineWidth: 1)
                )
                .onChange(of: isFocused) { _, newValue in
                    if !newValue {
                        textLen = textValue.wrappedValue.count
                    }
                }
        }
    }
    
    private var borderStrokeColor: Color {
        if !isFocused && textValue.wrappedValue.count < minLength && textValue.wrappedValue.count != 0 {
            return Color.accentRed
        }
        else if !isFocused {
            return Color.gray100
        } else if isFocused {
            return Color.pointSkyBlue
        } else {
            return Color.pointSkyBlue
        }
    }
}
