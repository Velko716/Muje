//
//  ApplicationManagementViewModel.swift
//  Muje
//
//  Created by 조재훈 on 8/14/25.
//

import Foundation
import FirebaseFirestore
import SwiftUI

@Observable
final class ApplicationManagementViewModel {
  
  private let firestoreManager = FirestoreManager.shared
  
  var isSelectionMode: Bool = false
  var isSticky: Bool = false
  
  var isSearching: Bool = false
  var searchText: String = ""
  
  // 모든 지원자들의 배열, 선택된 지원자의 ID 배열
  var allApplicants: [Application] = []
  var selectedApplicantId: Set<UUID> = []
  
  // 탭 선택과 지원 프로세스 상태관리
  var selectedTab: ApplicationTab = .management
  var selectedManagementStage: ApplicationStatus = .submitted
  
  // 프로세스 단계별 지원자 리스트를 위한 연산 프로퍼티
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
  // MARK: - 지원자 검색 기능
  private var currentBaseList: [Application] {
    switch selectedTab {
    case .management:
      return filterApplicants
    case .list:
      return allApplicants
    }
  }
  
  var searchFilterApplicants: [Application] {
    let baseList = currentBaseList
    
    if searchText.isEmpty {
      return baseList
    }
    
    return baseList.filter { applicant in
      applicant.applicantName.localizedCaseInsensitiveContains(searchText) ||
      (applicant.applicantDepartment?.localizedCaseInsensitiveContains(searchText) ?? false) || (applicant.applicantStudentId?.localizedStandardContains(searchText) ?? false)
    }
  }
  
  func getCurrentApplicant() -> [Application] {
    return searchFilterApplicants
  }
  
  func startSearching() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isSearching = true
    }
  }
  
  func endSearching() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isSearching = false
      searchText = ""
    }
  }
  
  func toggleSelection(_ applicationId: UUID) {
    if selectedApplicantId.contains(applicationId) {
      selectedApplicantId.remove(applicationId)
    } else {
      selectedApplicantId.insert(applicationId)
    }
  }
  
  func selectAll() {
    if selectedApplicantId.count == filterApplicants.count {
      selectedApplicantId.removeAll()
    } else {
      selectedApplicantId = Set(filterApplicants.map { $0.applicationId })
    }
  }
  // MARK: - 왼쪽 오른쪽 버튼 분기 처리
  func handleRightButtonAction() {
    switch selectedManagementStage {
    case .submitted:
      promoteApplicant()
    case .interviewWaiting:
      promoteApplicant()
    case .reviewWaiting:
      passApplicant()
    case .reviewCompleted:
      notifyAllResults()
    }
  }
  
  func handleLeftButtonAction() {
    switch selectedManagementStage {
    case .submitted, .interviewWaiting, .reviewWaiting:
      rejectApplicant()
    case .reviewCompleted:
      notifyAllResults()
    }
  }
  
  // MARK: - 이전 프로세스 단계로 변환
  func canMovePreviousStage(application: Application) -> Bool {
    return getPreviousStageStatus(from: application.status) != nil
  }
  
  private func getPreviousStageStatus(from currentStatus: String) -> String? {
    guard let currentStage = ApplicationStatus(rawValue: currentStatus) else {
      return nil
    }
    
    switch currentStage {
    case .submitted:
      return nil
    case .interviewWaiting:
      return ApplicationStatus.submitted.rawValue
    case .reviewWaiting:
      return ApplicationStatus.interviewWaiting.rawValue
    case .reviewCompleted:
      return ApplicationStatus.reviewWaiting.rawValue
    }
  }
  
  func moveApplicationToPreviousStage(applicationId: UUID) {
    guard let application = allApplicants.first(where: { $0.applicationId == applicationId }),
          let previousStatus = getPreviousStageStatus(from: application.status) else {
      return
    }
    
    updateApplicationStatus(
      applicantIds: [applicationId],
      newStatus: previousStatus,
      isPassed: nil
    )
  }
  
  func getPreviousStageDisplayName(for application: Application) -> String? {
    guard let previousStatus = getPreviousStageStatus(from: application.status),
          let previousStage = ApplicationStatus(rawValue: previousStatus) else {
      return nil
    }
    return previousStage.displayName
  }
  
  func getnextStatus(from currentStage: ApplicationStatus) -> String {
    switch currentStage {
    case .submitted:
      return ApplicationStatus.interviewWaiting.rawValue
    case .interviewWaiting:
      return ApplicationStatus.reviewWaiting.rawValue
    case .reviewWaiting:
      return ApplicationStatus.reviewCompleted.rawValue
    case .reviewCompleted:
      return ApplicationStatus.reviewCompleted.rawValue
    }
  }
  
  func exitSelectionMode() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isSelectionMode = false
    }
    selectedApplicantId.removeAll()
  }
  
  func exitSearchMode() {
      isSearching = false
  }
  
  func promoteApplicant() {
    guard !selectedApplicantId.isEmpty else { return }
    
    let nextStatus = getnextStatus(from: selectedManagementStage)
    
    updateApplicationStatus(
      applicantIds: Array(selectedApplicantId),
      newStatus: nextStatus
    )
    exitSelectionMode()
  }
  
  func rejectApplicant() {
    guard !selectedApplicantId.isEmpty else { return }
    
    updateApplicationStatus(
      applicantIds: Array(selectedApplicantId),
      newStatus: ApplicationStatus.reviewCompleted.rawValue,
      isPassed: false
    )
    exitSelectionMode()
  }
  
  func passApplicant() {
    guard !selectedApplicantId.isEmpty else { return }
    
    updateApplicationStatus(
      applicantIds: Array(selectedApplicantId),
      newStatus: ApplicationStatus.reviewCompleted.rawValue,
      isPassed: true
    )
    exitSelectionMode()
  }
  
  func notifyAllResults() {
    let _ = filterApplicants.filter { application in
      application.status == ApplicationStatus.reviewCompleted.rawValue
    }
    
    // TODO: 실제 알림 로직
  }
  
  func updateApplicationStatus(
    applicantIds: [UUID],
    newStatus: String,
    isPassed: Bool? = nil
  ) {
    
    for i in 0..<allApplicants.count {
      if applicantIds.contains(allApplicants[i].applicationId) {
        allApplicants[i].status = newStatus
        allApplicants[i].updatedAt = Timestamp()
        
        if let paseed = isPassed {
          allApplicants[i].isPassed = paseed
        }
      }
    }
    Task {
      await updateFirestore(
        applicantIds: applicantIds,
        newStatus: newStatus,
        isPaseed: isPassed
      )
    }
  }
}
// MARK: - 파베 관련 메서드
extension ApplicationManagementViewModel {
  func updateFirestore(
    applicantIds: [UUID],
    newStatus: String,
    isPaseed: Bool? = nil
  ) async {
    
    for applicationId in applicantIds {
      do {
        guard let index = allApplicants.firstIndex(where: { $0.applicationId == applicationId }) else { continue }
        
        var updatedApplication = allApplicants[index]
        updatedApplication.status = newStatus
        
        if let passed = isPaseed {
          updatedApplication.isPassed = passed
        }
        
        let _ = try await firestoreManager.update(updatedApplication)
        
        print("Firestore 업데이트 성공: \(applicationId)")
        
      } catch {
        print("Firestore 업데이트 실패 \(error)")
      }
    }
  }
  
  func loadApplicationData(for postId: String) async {
    do {
      let applicationData = try await fetchApplicationData(for: postId)
      self.allApplicants = applicationData
      
    } catch {
      print("지원자 정보 로드 실패")
    }
  }
  
  func fetchApplicationData(for postId: String) async throws -> [Application] {
    
    return try await firestoreManager.fetchWithCondition(
      from: .applications,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.createdAt?.dateValue() ?? Date() > $1.createdAt?.dateValue() ?? Date() }
    )
  }
}
