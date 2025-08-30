//
//  TopBarPrincipalTitle.swift
//  Muje
//
//  Created by 김진혁 on 8/20/25.
//

import SwiftUI

struct ToolbarCenterTitle: ToolbarContent {
    let text: String
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(text)
                .font(Font.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.black)
                .allowsHitTesting(false) // FIXME: - 가끔 리스트 버튼의 터치영역을 방해하는 요소를 제거하기 위해 구현 (존재 여부에 대해서 이야기)
        }
    }
}

#Preview {
    NavigationStack {
        Text("Preview")
            .toolbar {
                ToolbarCenterTitle(text: "안녕하세요")
            }
    }
}
