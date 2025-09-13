//
//  ApplicantDetailModalView.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import SwiftUI
import FirebaseFirestore

struct ApplicantDetailModalView: View {
  
  @State var viewModel: ModalViewModel
  @Binding var selectedApplicant: Application?
  
  @EnvironmentObject private var router: NavigationRouter
  @Environment(\.dismiss) private var dismiss
  
  private var interviewSlot: InterviewSlot? {
    return viewModel.getInterviewSlot()
  }
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        
        applicantInfoSection
        
        applicantInfoDetailSection
        
        contactButton
        
//        interviewStatus
        
        Rectangle()
          .frame(maxWidth: .infinity)
          .frame(height: 12)
          .foregroundStyle(Color.gray.opacity(0.2))
        
        customQuestionSection
        
      }
      .safeAreaInset(edge: .bottom) {
        BottomNavigationSection(
          viewModel: viewModel)
      }
    }
    .padding(.top, 16)
    .toolbar {
        ToolbarLeadingXmarkBackButton()
    }
    .task {
      await viewModel.loadQuestionAnswer()
    }
    .sheet(item: $viewModel.confirmationType) { type in
      ConfirmationModalView(type: type) {
        viewModel.Action(for: type)
        viewModel.confirmationType = nil
      } exitSheet: { selectedApplicant = nil }
        .presentationDetents([.fraction(0.3)])
    }
  }
  
  private var applicantInfoSection: some View {
    VStack(alignment: .leading) {
      Text(viewModel.currentApplicant.applicantName)
        .headline24SemiBold()
        .foregroundStyle(.grayblack)
      
      HStack {
        if (viewModel.currentApplicant.applicantGender != nil) {
          Text(viewModel.currentApplicant.genderDisplay)
            .body2Regular16()
            .foregroundStyle(.grayblack)
        }
        if (viewModel.currentApplicant.applicantBirthYear != nil) {
          Text(viewModel.currentApplicant.ageString)
            .body2Regular16()
            .foregroundStyle(.grayblack)
        }
        Spacer().frame(width: 12)
        statusSection
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 16)
    .padding(.bottom, 24)
  }
  
  private var statusSection: some View {
    HStack(spacing: 2) {
      // MARK: 지원자 상태 아이콘 분기
      viewModel.currentApplicant.statusIcon
        .foregroundStyle(viewModel.currentApplicant.statusColor)
      // MARK: 지원자 상태 텍스트 분기
      if viewModel.currentApplicant.interviewSlotId != nil {
        if viewModel.currentApplicant.status == ApplicationStatus.interviewWaiting.rawValue {
          Text(viewModel.currentApplicant.getInterviewDisplayText(with: interviewSlot))
            .foregroundStyle(viewModel.currentApplicant.statusColor)
        } else {
          Text(viewModel.currentApplicant.detailedStatusText)
            .foregroundStyle(viewModel.currentApplicant.statusColor)
        }
      } else {
        Text(viewModel.currentApplicant.detailedStatusText)
          .foregroundStyle(viewModel.currentApplicant.statusColor)
      }
    }
  }
  
  private var applicantInfoDetailSection: some View {
    VStack(alignment: .leading) {
      //      if requirementFlags.requiresPhone {
      //        InfoRow(title: "연락처", value: viewModel.userInfo?.phone ?? "")
      //      }
      if let studentId = viewModel.currentApplicant.applicantStudentId {
        InfoRow(title: "학번", value: studentId)
      }
      if let department = viewModel.currentApplicant.applicantDepartment {
        InfoRow(title: "학과", value: department)
      }
    }
    .padding(.bottom, 24)
  }
  
  private var contactButton: some View {
    VStack {
      Button {
        // TODO: 쪽지하기
      } label: {
        HStack(spacing: 6) {
          Image(.contact)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.gray100)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 24)
  }
  
//  private var interviewStatus: some View {
//    HStack {
//      Text("dd")
//        .padding(.horizontal, 16)
//      Spacer()
//      Text("dd")
//        .padding(.horizontal, 16)
//    }
//    .frame(maxWidth: .infinity)
//    .padding(.vertical, 21)
//    .background(Color.gray)
//    .clipShape(RoundedRectangle(cornerRadius: 10))
//    .padding(.horizontal, 16)
//    .padding(.bottom, 16)
//  }
  
  private var customQuestionSection: some View {
    VStack {
      ForEach(
        viewModel.questionAnswer.sorted(by: { $0.questionText < $1.questionText}),
        id: \.answerId
      ) { answer in
        QuestionAnswerToggle(
          question: answer.questionText,
          answer: answer.answerText
        )
      }
    }
  }
  
  
}

#Preview {
  NavigationStack {
    ApplicantDetailModalView(
      viewModel: ModalViewModel(
        managementViewModel: .preview,
        applicant: ApplicationManagementViewModel.preview.allApplicants.first!,
        allApplicants: ApplicationManagementViewModel.preview.allApplicants
      ),
      selectedApplicant: .constant(
        Application(
          applicationId: UUID(),
          applicantUserId: "",
          postId: "",
          status: ApplicationStatus.submitted.rawValue,
          applicantName: "제이콥",
          postTitle: "",
          postOrganization: "",
          postAuthorUserId: ""
        )
      )
    )
  }
}
