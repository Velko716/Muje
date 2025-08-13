//
//  ContentSection.swift
//  Muje
//
//  Created by 조재훈 on 8/12/25.
//

import SwiftUI
import FirebaseFirestore

extension ApplicationManagementView {
  var contentSection: some View {
    Group {
      switch selectedTab {
      case .management:
        applicantManagementContent
      case .list:
        applicantFullContent
      }
    }
  }
  
  private var applicantManagementContent: some View {
    VStack(alignment: .leading) {
//      managementTabSection
//      selectAndSearchBar
      applicantManagementList
    }
  }
  
  private var applicantFullContent: some View {
    VStack(alignment: .leading) {
//      searchBar
      applicantFullList
    }
  }
  
  var managementTabSection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        managementTabButton(stage: .submitted)
        managementTabButton(stage: .interviewWaiting)
        managementTabButton(stage: .reviewWaiting)
        managementTabButton(stage: .reviewCompleted)
      }
      .padding(.horizontal, 16)
    }
    .padding(.top, 16)
    .padding(.bottom, 8)
  }
  
  private func managementTabButton(stage: ApplicationStatus) -> some View {
    let isSelected = selectedManagementStage == stage
    
    return Text(stage.displayName)
      .font(.system(size: 16))
      .fontWeight(isSelected ? .bold : .medium)
      .padding(.horizontal, 16)
      .padding(.vertical, 13)
      .background(isSelected ? Color.primary : Color.gray)
      .foregroundStyle(isSelected ? .white : .primary)
      .clipShape(RoundedRectangle(cornerRadius: 100))
      .onTapGesture {
        withAnimation(.easeInOut(duration: 0.2)) {
          selectedManagementStage = stage
        }
      }
  }
  
  var selectAndSearchBar: some View {
    VStack {
      if isSelectionMode {
        HStack(spacing: 8) {
          Spacer()
          Button {
            selectAll()
          } label: {
            Text(selectedApplicantId.count == filterApplicants.count ? "전체 해제" : "전체 선택")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 20))
          }
          Button {
            isSelectionMode = false
            selectedApplicantId.removeAll()
          } label: {
            Text("취소")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 20))
          }
        }
        .padding(.trailing, 16)
      } else {
        HStack(spacing: 8) {
          Spacer()
          Button {
            isSelectionMode = true
          } label: {
            Text("선택")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 20))
          }
          Button {
            // TODO: - 리스트 검색 기능 구현
          } label: {
            Image(systemName: "magnifyingglass")
              .font(.system(size: 16))
              .padding(.vertical, 6)
              .padding(.horizontal, 8)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 100))
          }
        }
        .padding(.trailing, 16)
      }
    }
    .padding(.top, 4)
  }
  
  var searchBar: some View {
    HStack {
      Spacer()
      Button {
        // TODO: - 리스트 검색 기능 구현
      } label: {
        Image(systemName: "magnifyingglass")
          .font(.system(size: 16))
          .padding(.vertical, 6)
          .padding(.horizontal, 8)
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: 100))
      }
    }
    .padding(.top, 16)
    .padding(.trailing, 16)
  }
  
  var applicantManagementList: some View {
    VStack {
      if filterApplicants.isEmpty {
        VStack {
          Text("\(selectedManagementStage.displayName) 단계에\n지원자가 없습니다.")
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
      } else {
        LazyVStack(alignment: .leading, spacing: 16) {
          ForEach(Array(filterApplicants.enumerated()), id: \.element.applicationId) { index, application in
            applicantmanagementRow(application: application)
          }
        }
        .padding(.horizontal, 16)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.vertical, 12)
  }
  
  var applicantFullList: some View {
    VStack {
      if allApplicants.isEmpty {
        VStack {
          Text("아직 지원자가 없습니다.")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
      } else {
        LazyVStack(alignment: .leading, spacing: 16) {
          ForEach(Array(allApplicants.enumerated()), id: \.element.applicationId) { index, application in
              applicantList(application: application)
          }
        }
        .padding(.horizontal, 16)
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.vertical, 12)
  }
  
  private func applicantmanagementRow(application: Application) -> some View {
    
    let isSelected = selectedApplicantId.contains(application.applicationId)
    
    return HStack {
      VStack(alignment: .leading, spacing: 12) {
        Text(application.applicantName)
        HStack {
          if let _ = application.applicantGender {
            Text(application.genderDisplay)
          }
          if let _ = application.applicantBirthYear {
            Text(application.ageString)
          }
          if let department = application.applicantDepartment {
            Text("\(department)")
          }
          Spacer()
        }
        HStack {
          Image(systemName: application.statusIcon)
            .foregroundStyle(application.statusColor)
          Text(application.detailedStatusText)
            .foregroundStyle(application.statusColor)
          Spacer()
        }
      }
      HStack {
        if isSelectionMode {
          Button {
            toggleSelection(application.applicationId)
          } label: {
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 16)
    .background(
      isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.2)
    )
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
    )
    .contentShape(Rectangle())
    .onTapGesture {
      if isSelectionMode {
        toggleSelection(application.applicationId)
      } else {
        // TODO: - 지원자 상세 모달
      }
    }
  }
  
  private func applicantList(application: Application) -> some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text(application.applicantName)
          .font(.headline)
          .fontWeight(.medium)
        
        if let _ = application.applicantGender,
           let _ = application.applicantBirthYear {
          Text("\(application.genderDisplay) \(application.ageString)")
            .font(.subheadline)
        }
        Spacer()
      }
      HStack {
        if let department = application.applicantDepartment {
          Text("\(department)")
            .font(.subheadline)
        }
        Spacer()
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 18)
    .background(
      Color.gray.opacity(0.2)
    )
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.clear, lineWidth: 2)
    )
    .contentShape(Rectangle())
    .onTapGesture {
        // TODO: - 지원자 상세 모달
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
  
  
  // MARK: - 메서드
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
  }
  
  func notifyAllResults() {
    let _ = filterApplicants.filter { application in
      application.status == ApplicationStatus.reviewCompleted.rawValue
    }
    
    // TODO: 실제 알림 로직
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
        
        let _ = try await FirestoreManager.shared.update(updatedApplication)
        
        print("Firestore 업데이트 성공: \(applicationId)")
        
      } catch {
        print("Firestore 업데이트 실패 \(error)")
      }
    }
  }
  
  func exitSelectionMode() {
    withAnimation(.easeInOut(duration: 0.3)) {
      isSelectionMode = false
    }
    selectedApplicantId.removeAll()
  }
  
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
  
  func loadApplicationData(for postId: String) async {
    do {
      let applicationData = try await fetchApplicationData(for: postId)
      self.allApplicants = applicationData
      
    } catch {
      print("커스텀 질문 목록 로드 실패")
    }
  }
  
  func fetchApplicationData(for postId: String) async throws -> [Application] {
    
    return try await FirestoreManager.shared.fetchWithCondition(
      from: .applications,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.createdAt?.dateValue() ?? Date() > $1.createdAt?.dateValue() ?? Date() }
    )
  }
}

