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
            case .RecruitmentDetailView(let postId):
                RecruitmentDetailView(postId: postId)
            case .ApplicationFormView(let postId, let requirementFlags, let postBasicInfo):
              ApplicationFormView(
                postId: postId,
                requirementFlags: requirementFlags,
                postBasicInfo: postBasicInfo
              )
            case .ApplicationPreview(
              let postId,
              let requirementFlags,
              let postBasicInfo,
              let customQuestion,
              let questionAnswer
            ):
              ApplicationPreview(
                postId: postId,
                requirementFlags: requirementFlags,
                postBasicInfo: postBasicInfo,
                customQuestion: customQuestion,
                questionAnswer: .constant(questionAnswer)
              )
            case .emailVerificationView:
                EmailVerificationView()
            case .userInfoInputView(let uuid, let email):
                UserInfoInputView(uuid: uuid, email: email)
            case .makeRecruitmentView:
                RecruitmentSelectionItemView(IsBasicInfo: true, text: "지원자 정보", IsChecked: false)
            }
        }
        .hideBackButton()
        .environmentObject(router)
    }
}
