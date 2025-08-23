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
  
  @EnvironmentObject private var router: NavigationRouter
  
  private var interviewSlot: InterviewSlot? {
    return viewModel.getInterviewSlot()
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
          viewModel: viewModel
        )
      }
    }
//    .task {
//      await viewModel.loadQuestionAnswer()
//    }
    .sheet(item: $viewModel.confirmationType) { type in
      ConfirmationModalView(type: type) {
        viewModel.Action(for: type)
        viewModel.confirmationType = nil
      }
      .presentationDetents([.fraction(0.3)])
    }
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
      Text(viewModel.currentApplicant.applicantName)
      
      HStack {
        if (viewModel.currentApplicant.applicantGender != nil) {
          Text(viewModel.currentApplicant.genderDisplay)
        }
        if (viewModel.currentApplicant.applicantBirthYear != nil) {
          Text(viewModel.currentApplicant.ageString)
        }
        // MARK: 지원자 상태 아이콘 분기
        Image(systemName: viewModel.currentApplicant.statusIcon)
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
      if let studentId = viewModel.currentApplicant.applicantStudentId {
        InfoRow(title: "학번", value: studentId)
      }
      if let department = viewModel.currentApplicant.applicantDepartment {
        InfoRow(title: "학과", value: department)
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 24)
  }
  
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
  ApplicantDetailModalView(viewModel: .preview)
}
