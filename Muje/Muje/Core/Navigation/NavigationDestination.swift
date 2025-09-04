//
//  NavigationDestination.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import Foundation

enum NavigationDestination: Equatable, Hashable {
    case contentView // 임시
    case searchView
    case notificationView // 임시
    case RecruitmentDetailView(postId: String)
    case uploadCompleteView
    case myPostView
    case applicationFormView(
      postId: String,
      requirementFlags: RequirementFlags,
      postBasicInfo: PostBasicInfo
  ) 
    case applicationPreview(
      postId: String,
      requirementFlags: RequirementFlags,
      postBasicInfo: PostBasicInfo,
      customQuestion: [CustomQuestion],
      questionAnswer: [String: String]
  )
    case editContentView(post: Post, postImages: [PostImage])
    case applicationManagementView(
      postId: String,
      postInfo: ApplicationManagementPostInfo
    )
    case uploadPostView
    case emailVerificationView // 이메일 인증 뷰
    case userInfoInputView(uuid: String, email: String) // 유저 정보 입력 뷰
    case inboxView(conversationId: UUID)
    case myPageView // 설정 화면 (기존 탭 바에 있던 뷰가 홈 화면 툴 바 오른쪽 버튼으로 이동)
    case reportsHistoryView // 신고 내역
    case blockHistoryView // 차단 내역
    case textView(type: TextViewType) // 커뮤니티 이용 규칙, 서비스 이용약관, 개인정보 처리 방침, 청소년 보호 정책, 오픈 소스 라이선스
    case startLoginView // 로그인 시작화면
    case loginView // 로그인 뷰 (기존 유저)
    case registrationCompleteView(userName: String) // 회원가입 완료 뷰
}
