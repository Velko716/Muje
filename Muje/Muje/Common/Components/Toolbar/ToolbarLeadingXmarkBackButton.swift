//
//  ToolbarLeadingXmarkBackButton.swift
//  Muje
//
//  Created by 김진혁 on 8/29/25.
//

import SwiftUI

// FIXME: - ToolbarLeadingBackButton와 똑같은 기능을 하지만 이미지만 변경된 상태입니다. 2개로 나뉘어진 소스코드 파일을 하나의 파일로 합쳐, 추후 enum으로 분기 처리가 가능합니다.
/// 뒤로가기 버튼입니다.
struct ToolbarLeadingXmarkBackButton: ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(.iconCloseBlack)
                    .foregroundStyle(Color.black)
            }
        }
    }
}

#Preview {
    NavigationStack {
        Text("Preview")
            .toolbar {
                ToolbarLeadingXmarkBackButton()
            }
    }
}


