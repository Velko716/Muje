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
    
    func paddingH16() -> some View {
        self.padding(.horizontal, 16)
    }
}

