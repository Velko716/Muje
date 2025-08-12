//
//  ContentSection.swift
//  Muje
//
//  Created by 조재훈 on 8/12/25.
//

import SwiftUI

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
      managementTabSection
      selectAndSearchBar
      applicantManagementList
    }
  }
  
  private var applicantFullContent: some View {
    VStack(alignment: .leading) {
      searchBar
      applicantFullList
    }
  }
  
  private var managementTabSection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        managementTabButton(stage: .submitted)
        managementTabButton(stage: .interviewWaiting)
        managementTabButton(stage: .reviewWaiting)
        managementTabButton(stage: .reviewCompleted)
      }
      .padding(.horizontal, 16)
    }
    .padding(.vertical, 12)
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
        HStack(spacing: 16) {
          Spacer()
          Button {
            selectAll()
          } label: {
            Text(selectedApplicantId.count == filterApplicants.count ? "전체 해제" : "전체 선택")
          }
          Button {
            isSelectionMode = false
            selectedApplicantId.removeAll()
          } label: {
            Text("취소")
          }
        }
        .padding(.trailing, 16)
      } else {
        HStack(spacing: 16) {
          Spacer()
          Button {
            isSelectionMode = true
          } label: {
            Text("선택")
          }
          Button {
            // TODO: - 리스트 검색 기능 구현
          } label: {
            Image(systemName: "magnifyingglass")
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
}
