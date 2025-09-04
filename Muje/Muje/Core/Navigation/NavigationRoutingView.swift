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
            case .searchView:
              SearchView()
            case .notificationView:
                NotificationView()
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
            case .ApplicationManagementView(let postId, let postInfo):
              ApplicationManagementView(
                postId: postId,
                postInfo: postInfo
              )
            case .EditContentView(let post, let postImages):
              EditContentView(post: post, postImages: postImages)
            case .emailVerificationView:
                EmailVerificationView()
            case .userInfoInputView(let uuid, let email):
                UserInfoInputView(uuid: uuid, email: email)
            case .inboxView(let conversationId):
                InboxView(conversationId: conversationId)   
            case .myPageView:
                MyPageView()
            case .reportsHistoryView:
                ReportsHistoryView()
            case .blockHistoryView:
                BlockHistoryView()
            case .textView(let type):
                TextView(viewModel: TextViewModel(type: type)) // 커뮤니티 이용 규칙, 서비스 이용약관, 개인정보 처리 방침, 청소년 보호 정책, 오픈 소스 라이선스
            case .startLoginView:
                StartLoginView()
            case .registrationCompleteView(let userName):
                RegistrationCompleteView(userName: userName)
            case .loginView:
                LoginView()
            }
        }
        .hideBackButton()
        .dismissKeyboardOnTap()
        .environmentObject(router)
    }
}
