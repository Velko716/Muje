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
        .font(Font.system(size: 16, weight: .medium)) // FIXME: - 폰트 수정
        .keyboardType(keyboard)
        .padding(.horizontal, 16)
        .frame(height: 62)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 1) // FIXME: - 컬러 수정하기
        )
        .animation(.easeOut(duration: 0.15), value: isFocused)
        
    }
}

#Preview {
    RoundedTextField(text: .constant(""), placeholder: "@jbnu.ac.kr", keyboard: .emailAddress)
        .padding(.horizontal, 16)
}
