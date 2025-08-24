//
//  NavigationDestination.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import Foundation

enum NavigationDestination: Equatable, Hashable {
    case contentView // 임시
    case searchView(posts: [Post])
    case notificationView // 임시
    case RecruitmentDetailView(postId: String)
    case ApplicationFormView(
      postId: String,
      requirementFlags: RequirementFlags,
      postBasicInfo: PostBasicInfo
  )
    case ApplicationPreview(
      postId: String,
      requirementFlags: RequirementFlags,
      postBasicInfo: PostBasicInfo,
      customQuestion: [CustomQuestion],
      questionAnswer: [String: String]
  )
    case ApplicationManagementView(
      postId: String,
      postInfo: ApplicationManagementPostInfo
    )
    case emailVerificationView // 이메일 인증 뷰
    case userInfoInputView(uuid: String, email: String) // 유저 정보 입력 뷰
    case inboxView(conversationId: UUID)
    case myPageView // 설정 화면 (기존 탭 바에 있던 뷰가 홈 화면 툴 바 오른쪽 버튼으로 이동)
}
