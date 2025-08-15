//
//  ApplicationManagementRow.swift
//  Muje
//
//  Created by 조재훈 on 8/14/25.
//

import SwiftUI

struct ApplicationManagementRow: View {
  
  @Bindable var viewModel: ApplicationManagementViewModel
  
  let isSelected: Bool
  let application: Application
  
  var body: some View {
    HStack {
      infoSection
      selectSection
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
      if viewModel.isSelectionMode {
        viewModel.toggleSelection(application.applicationId)
      } else {
        // TODO: 지원자 상세 모달 구현
      }
    }
  }
  
  private var infoSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(application.applicantName)
      infoDetailSection
      markSection
    }
  }
  
  private var infoDetailSection: some View {
    HStack {
      if let _ = application.applicantGender {
        Text(application.genderDisplay)
      }
      if let _ = application.applicantBirthYear {
        Text(application.ageString)
      }
      if let department = application.applicantDepartment {
        Text(department)
      }
      Spacer()
    }
  }
  
  private var markSection: some View {
    HStack {
      Image(systemName: application.statusIcon)
        .foregroundStyle(application.statusColor)
      Text(application.detailedStatusText)
        .foregroundStyle(application.statusColor)
      Spacer()
    }
  }
  
  private var selectSection: some View {
    HStack {
      if viewModel.isSelectionMode {
        Button {
          viewModel.toggleSelection(application.applicationId)
        } label: {
          Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
        }
      }
    }
  }
}

#Preview {
  ApplicationManagementRow(
    viewModel: ApplicationManagementViewModel(), isSelected: true,
    application: Application(
      applicationId: UUID(),
      applicantUserId: "dddd",
      postId: "dddd",
      status: ApplicationStatus.submitted.rawValue,
      applicantName: "박기연",
      postTitle: "동아리 어쩌고",
      postOrganization: "MAD",
      postAuthorUserId: "dddd"
    )
  )
}
