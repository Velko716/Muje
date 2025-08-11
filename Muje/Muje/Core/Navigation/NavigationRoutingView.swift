//
//  NavigationRoutingView.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var router: NavigationRouter
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .contentView: // 임시
                RootView() // 임시
            case .emailVerificationView:
                EmailVerificationView()
            case .userInfoInputView(let uuid, let email):
                UserInfoInputView(uuid: uuid, email: email)                
            case .phoneVerificationView:
                PhoneVerificationView()
            }
        }
        .hideBackButton()
        .environmentObject(router)
    }
}
