//
//  ToolbarButtonStyle.swift
//  Muje
//
//  Created by 김진혁 on 8/20/25.
//

import SwiftUI

struct ToolbarImageButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.black) // FIXME: - 컬러 수정
            .frame(width: 24, height: 24) // TODO: 아이콘 크기 논의
    }
}

extension Image {
    /// 툴 바 기본 스타일 수정자입니다.
    func toolbarImageButtonStyle() -> some View {
        modifier(ToolbarImageButtonStyle())
    }
}
