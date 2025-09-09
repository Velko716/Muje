//
//  PlaceholderTextEditor.swift
//  Muje
//
//  Created by 김진혁 on 9/8/25.
//

import SwiftUI

/// 둥근 박스 스타일의 TextEditor + placeholder
struct PlaceholderTextEditor: View {
    @Binding var text: String
    var placeholder: String
    @FocusState private var focused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($focused)
                .font(Font.pretendard(type: .medium, size: 16))
                .foregroundStyle(Color.gray500)
                .padding(8)
                .frame(maxHeight: 212, alignment: .topLeading)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.white01)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.gray100, lineWidth: 1)
                )
            if text.isEmpty {
                Text(placeholder)
                    .font(Font.pretendard(type: .medium, size: 16))
                    .foregroundStyle(Color.gray500)
                    .padding([.top, .leading], 16)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    PlaceholderTextEditor(text: .constant(""), placeholder: "신고 내용을 상세하게 적어주세요")
}
