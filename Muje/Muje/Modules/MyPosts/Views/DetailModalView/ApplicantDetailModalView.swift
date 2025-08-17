//
//  ApplicantDetailModalView.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import SwiftUI

struct ApplicantDetailModalView: View {
  
  @EnvironmentObject private var router: NavigationRouter
  @Bindable var viewModel: ApplicationManagementViewModel
  
  let applicant: Application
  let allApplicants: [Application]
  
  private var currentApplicant: Application {
    allApplicants[currentIndex]
  }
  
  private var currentApplicationStatus: ApplicationStatus {
    ApplicationStatus(rawValue: currentApplicant.status) ?? .submitted
  }
  
  @State private var isLoading: Bool = false
  @State private var currentIndex: Int
  @State private var questionAnswer: [QuestionAnswer] = []
  
  @State private var confirmationType: ConfirmationModalType?
  
  init(
    viewModel: ApplicationManagementViewModel,
    applicant: Application,
    allApplicants: [Application]
  ) {
    self.viewModel = viewModel
    self.applicant = applicant
    self.allApplicants = allApplicants
    self._currentIndex = State(initialValue: allApplicants.firstIndex(where: { $0.applicationId == applicant.applicationId}) ?? 0)
  }
  
  var body: some View {
    VStack(spacing: 0) {
      navigationHeader
      ScrollView {
        
        applicantInfoSection
        
        applicantInfoDetailSection
        
        Rectangle()
          .frame(maxWidth: .infinity)
          .frame(height: 12)
          .foregroundStyle(Color.gray.opacity(0.2))
        
        customQuestionSection
        
      }
      
      VStack {
        BottomNavigationSection(
          viewModel: viewModel,
          currentIndex: $currentIndex,
          confirmationType: $confirmationType, allApplicant: allApplicants,
          currentApplicant: currentApplicant,
          currentApplicationStatus: currentApplicationStatus
        )
      }
    }
    .task {
      await loadQuestionAnswer()
    }
    .sheet(item: $confirmationType) { type in
      ConfirmationModalView(type: type) {
        Action(for: type)
        confirmationType = nil
      }
      .presentationDetents([.fraction(0.3)])
    }
  }
  
  private func Action(for type: ConfirmationModalType) {
    switch type {
    case .reject:
      handleLeftAction()
    case .promote, .pass, .completeInterview:
      handleRightAction()
    case .cancelInterview:
      handleLeftAction()
    case .notify:
      handleNotifyAction()
    }
  }
  
  private func handleLeftAction() {
    let currentApplicant = self.currentApplicant
    let status = currentApplicationStatus
    
    viewModel.selectedApplicantId.insert(currentApplicant.applicationId)
    
    switch status {
    case .submitted, .reviewWaiting:
      viewModel.rejectApplicant()
    case .interviewWaiting:
      viewModel.updateApplicationStatus(
        applicantIds: [currentApplicant.applicationId],
        newStatus: ApplicationStatus.submitted.rawValue
      )
      viewModel.selectedApplicantId.removeAll()
    case .reviewCompleted:
      break
    }
  }
  
  private func handleRightAction() {
    let currentApplicant = self.currentApplicant
    let status = currentApplicationStatus
    
    viewModel.selectedApplicantId.insert(currentApplicant.applicationId)
    
    switch status {
    case .submitted, .interviewWaiting:
      viewModel.promoteApplicant()
    case .reviewWaiting:
      viewModel.passApplicant()
    case .reviewCompleted:
      break
    }
  }
  
  private func handleNotifyAction() {
    print("\(currentApplicant.applicantName)에게 알림 발송")
  }
  
  private var navigationHeader: some View {
    HStack {
      Button {
        //
      } label: {
        Image(systemName: "xmark")
          .font(.system(size: 18))
          .foregroundStyle(Color.black)
      }
      Spacer()
    }
    .padding(.leading, 16)
    .padding(.top, 16)
  }
  
  private var applicantInfoSection: some View {
    VStack(alignment: .leading) {
      Text(currentApplicant.applicantName)
      
      HStack {
        if (currentApplicant.applicantGender != nil) {
          Text(currentApplicant.genderDisplay)
        }
        if (currentApplicant.applicantBirthYear != nil) {
          Text(currentApplicant.ageString)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
    .padding(.top, 35)
    .padding(.bottom, 24)
  }
  
  private var applicantInfoDetailSection: some View {
    VStack(spacing: 5) {
      //      if requirementFlags.requiresPhone {
      //        InfoRow(title: "연락처", value: viewModel.userInfo?.phone ?? "")
      //      }
      if let studentId = currentApplicant.applicantStudentId {
        InfoRow(title: "학번", value: studentId)
      }
      if let department = currentApplicant.applicantDepartment {
        InfoRow(title: "학과", value: department)
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 24)
  }
  
  private var customQuestionSection: some View {
    VStack {
      ForEach(
        questionAnswer.sorted(by: { $0.questionText < $1.questionText}),
        id: \.answerId
      ) { answer in
        QuestionAnswerToggle(
          question: answer.questionText,
          answer: answer.answerText
        )
      }
    }
  }
  
  private func loadQuestionAnswer() async {
    do {
      isLoading = true
      
      let answers: [QuestionAnswer] = try await FirestoreManager.shared.fetchWithCondition(
        from: .questionAnswers,
        whereField: "application_id",
        equalTo: currentApplicant.applicationId.uuidString,
        sortedBy: { $0.createdAt?.dateValue() ?? Date() < $1.createdAt?.dateValue() ?? Date() }
      )
      
      await MainActor.run {
        self.questionAnswer = answers
        self.isLoading = false
        
      }
    } catch {
      print("지원자의 질문 답변 로드 실패")
    }
  }
}

struct ConfirmationModalItem: Identifiable {
  let id = UUID()
  let type: ConfirmationModalType
}

#Preview {
  ApplicantDetailModalView(
    viewModel: ApplicationManagementViewModel(),
    applicant: Application(
      applicationId: UUID(),
      applicantUserId: "user1",
      postId: "post1",
      status: ApplicationStatus.submitted.rawValue,
      applicantName: "김철수",
      applicantBirthYear: 2000,
      applicantGender: "M",
      applicantDepartment: "컴퓨터공학과",
      applicantStudentId: "202012345",
      applicantPhone: "010-1234-5678",
      postTitle: "프로그래밍 동아리 모집",
      postOrganization: "코딩클럽",
      postAuthorUserId: "author1"),
    allApplicants: [Application(
      applicationId: UUID(),
      applicantUserId: "user1",
      postId: "post1",
      status: ApplicationStatus.submitted.rawValue,
      applicantName: "김철수",
      applicantBirthYear: 2000,
      applicantGender: "M",
      applicantDepartment: "컴퓨터공학과",
      applicantStudentId: "202012345",
      applicantPhone: "010-1234-5678",
      postTitle: "프로그래밍 동아리 모집",
      postOrganization: "코딩클럽",
      postAuthorUserId: "author1"
    ),
                    Application(
                      applicationId: UUID(),
                      applicantUserId: "user1",
                      postId: "post1",
                      status: ApplicationStatus.submitted.rawValue,
                      applicantName: "김철수",
                      applicantBirthYear: 2000,
                      applicantGender: "M",
                      applicantDepartment: "컴퓨터공학과",
                      applicantStudentId: "202012345",
                      applicantPhone: "010-1234-5678",
                      postTitle: "프로그래밍 동아리 모집",
                      postOrganization: "코딩클럽",
                      postAuthorUserId: "author1"
                    ),
                    Application(
                      applicationId: UUID(),
                      applicantUserId: "user1",
                      postId: "post1",
                      status: ApplicationStatus.submitted.rawValue,
                      applicantName: "김철수",
                      applicantBirthYear: 2000,
                      applicantGender: "M",
                      applicantDepartment: "컴퓨터공학과",
                      applicantStudentId: "202012345",
                      applicantPhone: "010-1234-5678",
                      postTitle: "프로그래밍 동아리 모집",
                      postOrganization: "코딩클럽",
                      postAuthorUserId: "author1"
                    ),
                    Application(
  applicationId: UUID(),
  applicantUserId: "user1",
  postId: "post1",
  status: ApplicationStatus.submitted.rawValue,
  applicantName: "김철수",
  applicantBirthYear: 2000,
  applicantGender: "M",
  applicantDepartment: "컴퓨터공학과",
  applicantStudentId: "202012345",
  applicantPhone: "010-1234-5678",
  postTitle: "프로그래밍 동아리 모집",
  postOrganization: "코딩클럽",
  postAuthorUserId: "author1"
)]
  )
}
