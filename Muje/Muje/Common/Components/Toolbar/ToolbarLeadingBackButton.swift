//
//  TopBarLeadingBackButton.swift
//  Muje
//
//  Created by 김진혁 on 8/20/25.
//

import SwiftUI

/// 뒤로가기 버튼입니다.
struct ToolbarLeadingBackButton: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left") // FIXME: - 이미지 열거형으로 만들기
                    .foregroundStyle(Color.black)
                    .frame(width: 24, height: 24)
            }
        }
    }
}

#Preview {
    NavigationStack {
        Text("Preview")
            .toolbar {
                ToolbarLeadingBackButton() 
            }
    }
}
