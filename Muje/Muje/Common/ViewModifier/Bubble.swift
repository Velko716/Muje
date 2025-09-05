//
//  Bubble.swift
//  Muje
//
//  Created by 김진혁 on 8/20/25.
//

import SwiftUI


struct Bubble: ViewModifier {
    let color: Color
    let isBorder: Bool
    
    func body(content: Content) -> some View {
        content
            .font(Font.pretendard(type: .medium, size: 16))
            .foregroundStyle(Color.gray700)
            .lineSpacing(16 * 0.85)
            .tracking(16 * -0.01)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                if isBorder {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.gray200, lineWidth: 0.5)
                }
            }
    }
}

extension View {
    /// 말풍선 모양의 수정자입니다.
    ///
    /// - color:말풍선 색상
    /// - isBorder: 테두리의 여부
    func bubble(color: Color, isBorder: Bool) -> some View {
        modifier(Bubble(color: color, isBorder: isBorder))
    }
}
