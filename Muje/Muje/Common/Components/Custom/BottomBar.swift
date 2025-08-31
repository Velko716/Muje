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
            .fill(Color.gray) // FIXME: - 컬러 수정 DCDCDC
            .frame(height: 0.5)
        
        Spacer().frame(height: 20)
        
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 18, weight: .semibold)) // FIXME: - 폰트 수정
                .foregroundStyle(enabled ? Color.white : textColor) // FIXME: - 컬러 수정
                .frame(maxWidth: .infinity, maxHeight: 54)
            
        }
        .disabled(enabled)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(enabled ? Color.secondary : bgColor) // FIXME: - 컬러 수정
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    BottomBar(text: "시작하기", textColor: Color.white, bgColor: Color.black, enabled: false) { }
}
