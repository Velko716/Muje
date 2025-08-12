//
//  ApplicationManagementView.swift
//  Muje
//
//  Created by 조재훈 on 8/11/25.
//

import SwiftUI

struct ApplicationManagementView: View {
  
  // 탭 선택
  @State var selectedTab: ApplicationTab = .management
  // 지원자 프로세스 관리
  @State var selectedManagementStage: ManagementStage = .submitted
  // 선택 모드 관련 상태
  @State var isSelectionMode: Bool = false
  
  @State private var allApplicants: [Application] = []
  @State var selectedApplicantId: Set<UUID> = []
  
  let postId: String
  
  var body: some View {
    VStack {
      CustomNavigationBar(
        title: "내가 올린 공고") {
          // 네비게이션 연결
        }
      ScrollView {
        postInfoSection
        tabSelctionSection
        contentSection
        applicantManagementList
      }
    }
    .onAppear {
      loadData()
    }
  }
  
  var filterApplicants: [Application] {
    return allApplicants.filter { application in
      switch selectedManagementStage {
      case .submitted:
        return application.status == ApplicationStatus.submitted.rawValue
      case .interviewWaiting:
        return application.status == ApplicationStatus.interviewWaiting.rawValue
      case .reviewWaiting:
        return application.status == ApplicationStatus.reviewWaiting.rawValue
      case .reviewCompleted:
        return application.status == ApplicationStatus.reviewCompleted.rawValue
      }
    }
  }
  
  
  private func loadData() {
    
    print("Loading data for postId: \(postId)")
    
    // 임시 테스트 데이터 생성
    allApplicants = [
      Application(
        applicationId: UUID(),
        applicantUserId: "user1",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        applicantName: "제이콥",
        applicantBirthYear: 2000,
        applicantGender: "M",
        applicantDepartment: "커뮤니케이션학과",
        applicantStudentId: "202012345",
        applicantPhone: "010-1234-5678",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user2",
        postId: postId,
        status: ApplicationStatus.interviewWaiting.rawValue,
        applicantName: "헤리",
        applicantBirthYear: 2001,
        applicantGender: "F",
        applicantDepartment: "컴퓨터공학과",
        applicantStudentId: "202112345",
        applicantPhone: "010-2345-6789",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user3",
        postId: postId,
        status: ApplicationStatus.reviewWaiting.rawValue,
        applicantName: "카단",
        applicantBirthYear: 1999,
        applicantGender: "M",
        applicantDepartment: "경영학과",
        applicantStudentId: "201912345",
        applicantPhone: "010-3456-7890",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      // 더 많은 테스트 데이터 추가
      Application(
        applicationId: UUID(),
        applicantUserId: "user4",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        applicantName: "벨고",
        applicantBirthYear: 2002,
        applicantGender: "M",
        applicantDepartment: "디자인학과",
        applicantStudentId: "202212345",
        applicantPhone: "010-4567-8901",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      )
    ]
  }
}


#Preview {
  ApplicationManagementView(postId: "post_id")
}
