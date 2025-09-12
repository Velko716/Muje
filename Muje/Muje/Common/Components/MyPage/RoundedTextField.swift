//
//  RoundedTextField.swift
//  Muje
//
//  Created by 김진혁 on 8/31/25.
//

import SwiftUI

struct RoundedTextField: View {
    @Binding var text: String
    var placeholder: String
    var keyboard: UIKeyboardType
    var isSecure: Bool = false
    var overlayColorBule: Bool = false // FIXME: - 분기처리를 위한 임시 변수
    let config = Font.lineHeight(type: .medium, fontSize: 16, lineHeightPercent: 1.85, letterSpacingPercent: -1)
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .focused($isFocused)
        .font(.pretendard(type: .medium, size: 16))
        .padding(.vertical, config.verticalPadding)
        .tracking(config.letterSpacing)
        .keyboardType(keyboard)
        .padding(.horizontal, 16)
        .frame(height: 62)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .overlay {
            if isSecure {
                if overlayColorBule {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1) // FIXME: - 컬러 수정하기
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.red : Color.gray, lineWidth: 1) // FIXME: - 컬러 수정하기
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? .pointSkyBlue : .gray100, lineWidth: 1)
            }
        }
        .animation(.easeOut(duration: 0.15), value: isFocused)
        
    }
}

#Preview {
    RoundedTextField(text: .constant(""), placeholder: "@jbnu.ac.kr", keyboard: .emailAddress)
        .padding(.horizontal, 16)
}
