//
//  TopNavigationView.swift
//  Muje
//
//  Created by 김서현 on 8/28/25.
//

import SwiftUI

struct TopNavigationView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        HStack {
            Text("oo대학교 모임 찾기")
                .subheadline22semibold()
                .foregroundStyle(.gray700)
            Spacer()
            
            //MARK: 검색 아이콘
            Button(action: {
                router.push(to: .searchView)
            }) {
                Image(.searchIcon)
                    .foregroundStyle(.gray600)
            }
            Spacer().frame(width: 16)
            //MARK: 알림 아이콘
            Button(action: {
                router.push(to: .notificationView)
            }) {
                Image(.alarmIcon)
                    .foregroundStyle(.gray600)
            }
            Spacer().frame(width: 16)
            //MARK: 설정 아이콘
            Button(action: {
                router.push(to: .myPageView) //FIXME: 설정뷰로 수정
            }) {
                Image(.settingIcon)
                    .foregroundStyle(.gray600)
            }
        } //: HSTACK
        .padding(.bottom, 25)
        .padding(.top, 20)
    }
}

#Preview {
    TopNavigationView()
}
