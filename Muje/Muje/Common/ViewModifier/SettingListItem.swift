//
//  SettingListItem.swift
//  Muje
//
//  Created by 김진혁 on 8/25/25.
//

import SwiftUI

struct SettingListItem: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 16, weight: .medium)) // FIXME: - 폰트 수정
            .foregroundStyle(color)
            .padding(.vertical, 20)
    }
}

extension View {
    func settingListItem(color: Color) -> some View {
        modifier(SettingListItem(color: color))
    }
}
