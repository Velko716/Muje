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
                Image(.che) // FIXME: - 이미지 열거형으로 만들기
              // MARK: 기존 세오 셰브론 -> SVG로 추출한 che로 변경
                    .foregroundStyle(Color.gray700)
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, -8)
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
