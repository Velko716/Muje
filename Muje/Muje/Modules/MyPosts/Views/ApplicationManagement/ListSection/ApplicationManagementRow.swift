//
//  ApplicationManagementRow.swift
//  Muje
//
//  Created by 조재훈 on 8/14/25.
//

import SwiftUI

struct ApplicationManagementRow: View {
  
  @Bindable var viewModel: ApplicationManagementViewModel
  
  @State private var showPreviousStageActionSheet: Bool = false
  @State private var isLongPressed: Bool = false
  
  let isSelected: Bool
  let application: Application
  let onTap: () -> Void
  
  private var interviewSlot: InterviewSlot? {
    viewModel.getInterviewSlot(for: application)
  }
  
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
    .scaleEffect(isLongPressed ? 1.05 : 1.0)
    .shadow(
      color: .black.opacity(
        isLongPressed ? 0.2 : 0
      ),
      radius: isLongPressed ? 8 : 0,
      x: 0,
      y: isLongPressed ? 4 : 0
    )
    .animation(.easeInOut(duration: 0.5), value: isLongPressed)
    .contentShape(Rectangle())
    .onTapGesture {
      if viewModel.isSelectionMode {
        viewModel.toggleSelection(application.applicationId)
      } else {
        onTap()
      }
    }
    .onLongPressGesture(
      minimumDuration: 0.5,
      perform: {
        handleLongPress()
      },
      onPressingChanged: { pressing in
        withAnimation(.easeInOut(duration: 0.15)) {
          isLongPressed = pressing
        }
      })
    .alert("이전 단계로 되돌리기", isPresented: $showPreviousStageActionSheet) {
      previousStageAcionButton
    } message: {
      Text("\(application.applicantName)님을 이전 단계로 되돌리시겠습니까?")
    }
    // TODO:
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
      
      if application.interviewSlotId != nil {
        if application.status == ApplicationStatus.interviewWaiting.rawValue {
          Text(application.getInterviewDisplayText(with: interviewSlot))
            .foregroundStyle(application.statusColor)
        } else {
          Text(application.detailedStatusText)
            .foregroundStyle(application.statusColor)
        }
      } else {
        Text(application.detailedStatusText)
          .foregroundStyle(application.statusColor)
      }
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
  
  @ViewBuilder
  private var previousStageAcionButton: some View {
    if let displayName = viewModel.getPreviousStageDisplayName(for: application) {
      Button("\(displayName)로 되돌리기") {
        viewModel.moveApplicationToPreviousStage(applicationId: application.applicationId)
      }
    }
    Button("취소", role: .cancel) {}
  }
  
  private func handleLongPress() {
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    impactFeedback.impactOccurred()
    
    if viewModel.canMovePreviousStage(application: application) {
      showPreviousStageActionSheet = true
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
    ), onTap: {}
  )
}
