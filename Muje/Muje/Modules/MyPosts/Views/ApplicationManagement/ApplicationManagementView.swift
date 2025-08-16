//
//  ApplicationManagementView.swift
//  Muje
//
//  Created by 조재훈 on 8/11/25.
//

import SwiftUI
import FirebaseFirestore

struct ApplicationManagementView: View {
  
  @State var viewModel: ApplicationManagementViewModel = .init()
  @FocusState var isSearchFieldFocused: Bool
  
  let postId: String
  let postInfo: ApplicationManagementPostInfo
  
  var body: some View {
    VStack(spacing: 0) {
      CustomNavigationBar(
        title: "내가 올린 공고") {
          // 네비게이션 연결
        }
      ScrollViewReader { proxy in
        ScrollView {
          LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
            postInfoSection
              .id("contentTop")
              .transaction { t in
                t.disablesAnimations = true }
              .padding(.bottom, 8)
            
            Section {
              contentSection
            } header: {
              stickyHeader
            }
          }
        }
        .animation(.none, value: viewModel.selectedTab)
        .animation(.none, value: viewModel.selectedManagementStage)
        .onChange(of: viewModel.selectedManagementStage) {
          withAnimation(.easeInOut(duration: 0.5)) {
            proxy.scrollTo("contentTop", anchor: .top)
          }
        }
        .onChange(of: viewModel.selectedTab) {
          withAnimation(.easeInOut(duration: 0.5)) {
            proxy.scrollTo("contentTop", anchor: .top)
          }
        }
      }
      Group {
        if viewModel.selectedTab == .management {
          bottomButtonj
        }
      }
      .transition(.identity) // 그룹에 적용
      .animation(nil, value: viewModel.selectedTab)
    }
    //    .onAppear {
    //      loadData()
    //    }
    .task {
      await viewModel.loadApplicationData(for: postId)
    }
  }
  
  private var stickyHeader: some View {
    VStack(spacing: 0) {
      tabSelctionSection
        .padding(.top, 8)
        .background(Color.white)
      if viewModel.selectedTab == .management && !viewModel.isSelectionMode {
        VStack(spacing: 0) {
          managementTabSection
            .background(Color.white)
          selectAndSearchBar
        }
      } else if viewModel.selectedTab == .management && viewModel.isSelectionMode {
        VStack(spacing: 0) {
          selectAndSearchBar
        }
        .padding(.top, 16)
      } else {
        VStack {
          searchBar
        }
      }
    }
    .zIndex(1)
  }
  
  private var managementTabSection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        ForEach(ApplicationStatus.allCases, id: \.self) { stage in
          ManagementTabButton(
            viewModel: viewModel,
            isSelected: viewModel.selectedManagementStage == stage,
            stage: stage
          )
        }
      }
      .padding(.horizontal, 16)
    }
  }
  
  private var contentSection: some View {
    Group {
      switch viewModel.selectedTab {
      case .management:
        applicantManagementList
      case .list:
        applicantFullList
      }
    }
  }
  

  
  // MARK: - 프리뷰용 목데이터
  private func loadData() {
    
    print("Loading data for postId: \(postId)")
    
    // 임시 테스트 데이터 생성
    viewModel.allApplicants = [
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
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
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
  ApplicationManagementView(
    postId: "post_id",
    postInfo: ApplicationManagementPostInfo(
      from: Post(
        postId: UUID(),
        authorUserId: "dd",
        title: "집에 가고 싶다~",
        organization: "MAD",
        content: "",
        recruitmentStart: Timestamp(date: Date()),
        recruitmentEnd: Timestamp(date: Date()),
        hasInterview: true,
        status: PostStatus.recruiting.rawValue,
        authorName: "dd",
        authorOrganization: "MAD"
      )
    )
  )
}
