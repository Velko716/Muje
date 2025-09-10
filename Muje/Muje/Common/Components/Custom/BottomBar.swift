//
//  BottomBar.swift
//  Muje
//
//  Created by 김진혁 on 8/31/25.
//

import SwiftUI

///바텀 하단 바 재사용 뷰 입니다.
/// - text: 버튼의 텍스트
/// - textColor: 버튼 텍스트 색상
/// - bgColor: 버튼의 백그라운드 색상
/// - enabled: 버튼의 허용 여부
/// - action : 버튼의 액션
struct BottomBar: View {
    let text: String
    let textColor: Color
    let bgColor: Color
    let enabled: Bool
    let action: () -> Void
    
    var body: some View {
        Rectangle()
            .fill(Color.gray100)
            .frame(height: 0.5)
        
        Spacer().frame(height: 20)
        
        Button {
            action()
        } label: {
            Text(text)
                .font(Font.pretendard(type: .semiBold, size: 18))
                .foregroundStyle(enabled ? textColor : Color.gray400)
                .frame(maxWidth: .infinity, maxHeight: 54)
            
        }
        .disabled(!enabled)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(enabled ? bgColor : Color.gray200)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    BottomBar(text: "시작하기", textColor: Color.white, bgColor: Color.black, enabled: false) { }
    BottomBar(text: "시작하기", textColor: Color.white, bgColor: Color.black, enabled: true) { }
}
