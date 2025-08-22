//
//  View+.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import SwiftUI

extension View {
    /// 네비게이션 이동 시 자동으로 생성되는 뒤로가기 버튼을 제거합니다.
    func hideBackButton() -> some View {
        self.navigationBarBackButtonHidden(true)
    }
    
    /// 아무 곳 터치 시, 키보드 창 내립니다.
    func dismissKeyboardOnTap() -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture {
            #if canImport(UIKit)
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil, from: nil, for: nil
                )
            #endif
            }
    }
    
    /// 기본 여백 좌우 16입니다.
    func paddingH16() -> some View {
        self.padding(.horizontal, 16)
    }
}

