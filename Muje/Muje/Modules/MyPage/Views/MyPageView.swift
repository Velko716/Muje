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
        VStack {
            Button {
                router.push(to: .emailVerificationView)
            } label: {
                Text("로그인 해주세요 >")
                    .font(.largeTitle)
                    .bold()
            }
            
            Spacer().frame(height: 100)
            
            // FIXME: - 임시
            Button {
                Task {
                    try await FirebaseAuthManager.shared.currentUserSignOut()
                    FirebaseAuthManager.shared.currentUser = nil
                }
            } label: {
                Text("로그아웃")
            }
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(NavigationRouter())
}
