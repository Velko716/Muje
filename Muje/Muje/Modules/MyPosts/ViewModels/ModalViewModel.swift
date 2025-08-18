//
//  ModalViewModel.swift
//  Muje
//
//  Created by 조재훈 on 8/18/25.
//

import Foundation

@Observable
final class ModalViewModel {
  
  private let managementViewModel: ApplicationManagementViewModel
  private let firestoreManager = FirestoreManager.shared
  
  var allApplicants: [Application]
  var applicant: Application
  
  var currentApplicant: Application {
    allApplicants[currentIndex]
  }
  
  var currentIndex: Int
  var currentApplicationStatus: ApplicationStatus {
    ApplicationStatus(rawValue: currentApplicant.status) ?? .submitted
  }
  var confirmationType: ConfirmationModalType?
  
  var isLoading: Bool = false
  var questionAnswer: [QuestionAnswer] = []
  
  init(managementViewModel: ApplicationManagementViewModel, applicant: Application, allApplicants: [Application]) {
    self.managementViewModel = managementViewModel
    self.allApplicants = allApplicants
    self.applicant = applicant
    self.currentIndex = allApplicants.firstIndex(where: { $0.applicationId == applicant.applicationId}) ?? 0
  }
  
  // MARK: 지원자의 면접 슬롯 정보 가져오기
  func getInterviewSlot() -> InterviewSlot? {
    return managementViewModel.getInterviewSlot(for: currentApplicant)
  }
  
  func Action(for type: ConfirmationModalType) {
    switch type {
    case .reject:
      handleLeftAction()
    case .promote, .pass, .completeInterview:
      return handleRightAction()
    case .cancelInterview:
      return handleLeftAction()
    case .notify:
      handleNotifyAction()
    }
  }
  
  func showConfirmationModal(for buttonType: ButtonType) {
    let name = currentApplicant.applicantName
    let status = currentApplicationStatus
    
    switch buttonType {
    case .left:
      switch status {
      case .submitted, .reviewWaiting:
        confirmationType = .reject(name)
      case .interviewWaiting:
        confirmationType = .cancelInterview(name)
      case .reviewCompleted:
        break
      }
    case .right:
      switch status {
      case .submitted:
        confirmationType = .promote(name)
      case .interviewWaiting:
        confirmationType = .completeInterview(name)
      case .reviewWaiting:
        confirmationType = .pass(name)
      case .reviewCompleted:
        break
      }
    }
  }
  
  private func handleLeftAction() {
    let currentApplicant = self.currentApplicant
    let status = currentApplicationStatus
    
    managementViewModel.selectedApplicantId.insert(currentApplicant.applicationId)
    
    switch status {
    case .submitted, .reviewWaiting:
      managementViewModel.rejectApplicant()
    case .interviewWaiting:
      managementViewModel.updateApplicationStatus(
        applicantIds: [currentApplicant.applicationId],
        newStatus: ApplicationStatus.submitted.rawValue
      )
      managementViewModel.selectedApplicantId.removeAll()
    case .reviewCompleted:
      break
    }
  }
  
  func handleRightAction() {
    let currentApplicant = self.currentApplicant
    let status = currentApplicationStatus
    
    managementViewModel.selectedApplicantId.insert(currentApplicant.applicationId)
    
    switch status {
    case .submitted, .interviewWaiting:
      managementViewModel.promoteApplicant()
    case .reviewWaiting:
      managementViewModel.passApplicant()
    case .reviewCompleted:
      break
    }
  }
  
  func handleNotifyAction() {
    print("\(currentApplicant.applicantName)에게 알림 발송")
  }
  
  func moveToPrevious() {
    if currentIndex > 0 {
      currentIndex -= 1
    }
  }
  
  func moveToNext() {
    if currentIndex < allApplicants.count - 1 {
      currentIndex += 1
    }
  }
}

extension ModalViewModel {
  func loadQuestionAnswer() async {
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
