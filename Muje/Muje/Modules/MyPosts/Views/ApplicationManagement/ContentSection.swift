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
        applicantManagementContent
      }
    }
  }
  
  private var applicantManagementContent: some View {
    VStack(alignment: .leading) {
      managementTabSection
      selectAndSearch
    }
  }
  
  private var managementTabSection: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 8) {
        managementTabButton("지원서 제출", stage: .submitted)
        managementTabButton("면접 대기", stage: .interviewWaiting)
        managementTabButton("심사 대기", stage: .reviewWaiting)
        managementTabButton("심사 완료", stage: .reviewCompleted)
      }
      .padding(.horizontal, 16)
    }
    .padding(.vertical, 12)
  }
  
  private func managementTabButton(_ title: String, stage: ManagementStage) -> some View {
    let isSelected = selectedManagementStage == stage
    
    return Text(title)
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
  
  var selectAndSearch: some View {
    VStack {
      if isSelectionMode {
        HStack(spacing: 16) {
          Spacer()
          Button {
            
          } label: {
            Text("전체 선택")
          }
          Button {
            isSelectionMode = false
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
            //
          } label: {
            Image(systemName: "magnifyingglass")
          }
        }
        .padding(.trailing, 16)
      }
    }
    .padding(.top, 4)
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
        LazyVStack(alignment: .leading) {
          ForEach(Array(filterApplicants.enumerated()), id: \.element.applicationId) { index, application in
            applicantmanagementRow(application: application)
          }
        }
        .padding(.horizontal, 16)
      }
    }
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
        
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 16)
    .background(
      isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.2)
    )
  }
}
