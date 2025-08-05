//
//  MyPageView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        Button {
            router.push(to: .emailVerificationView)
        } label: {
            Text("로그인 해주세요 >")
                .font(.largeTitle)
                .bold()
        }
    }
}

#Preview {
    MyPageView()
}
