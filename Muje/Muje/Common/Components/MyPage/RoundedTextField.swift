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
        .font(Font.pretendard(type: .medium, size: 16))
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
                        .stroke(isFocused ? Color.pointSkyBlue : Color.gray100, lineWidth: 1)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.accentRed : Color.gray100, lineWidth: 1)
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.pointSkyBlue : Color.gray100, lineWidth: 1)
            }
        }
        .animation(.easeOut(duration: 0.15), value: isFocused)
        
    }
}

#Preview {
    RoundedTextField(text: .constant(""), placeholder: "@jbnu.ac.kr", keyboard: .emailAddress)
        .padding(.horizontal, 16)
}
