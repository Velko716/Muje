//
//  BottomNavigationSection.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import SwiftUI

struct BottomNavigationSection: View {
  
  @Bindable var viewModel: ApplicationManagementViewModel
  
  @Binding var currentIndex: Int
  @Binding var confirmationType: ConfirmationModalType?
  
  let allApplicant: [Application]
  let currentApplicant: Application
  let currentApplicationStatus: ApplicationStatus
  
  
//  let action: () -> Void
  
  var body: some View {
    VStack {
      if allApplicant.count > 1 {
        navigatorSection
      }
      Divider()
      bottomButtonSection
    }
    .padding(.top, 16)
    .padding(.horizontal, 16)
  }
  
  private var navigatorSection: some View {
    HStack {
      Button {
        moveToPrevious()
      } label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 16))
          .foregroundStyle(currentIndex > 0 ? Color.black : Color.gray)
      }
      .disabled(currentIndex <= 0)
      Spacer()
      Text("\(currentApplicant.applicantName) (\(currentIndex + 1)/\(allApplicant.count))")
        .font(.system(size: 16))
        .foregroundStyle(Color.black)
      Spacer()
      Button {
        moveToNext()
      } label: {
        Image(systemName: "chevron.right")
          .font(.system(size: 16))
          .foregroundStyle(currentIndex < allApplicant.count - 1 ? Color.black : Color.gray)
      }
      .disabled(currentIndex >= allApplicant.count - 1)
    }
    .padding(.vertical, 16)
  }
  
  private func moveToPrevious() {
    if currentIndex > 0 {
      currentIndex -= 1
    }
  }
  
  private func moveToNext() {
    if currentIndex < allApplicant.count - 1 {
      currentIndex += 1
    }
  }
  
  private var bottomButtonSection: some View {
    VStack {
      modalButton(currentApplicationStatus.modalButtonType)
    }
  }
  
  private func modalButton(_ type: DetailModalButtonType) -> some View {
    Group {
      switch type {
      case .twoButton(let left, let right):
        HStack(spacing: 16) {
          Button {
            showConfirmationModal(for: .left)
          } label: {
            Text(left)
              .font(.system(size: 18))
              .foregroundStyle(Color.black)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(Color.gray)
          }
          Button {
            showConfirmationModal(for: .right)
          } label: {
            Text(right)
              .font(.system(size: 18))
              .foregroundStyle(Color.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(Color.black)
          }
        }
        .padding(.vertical, 16)
      case .singleButton(let title):
        Button {
          confirmationType = .notify(currentApplicant.applicantName)
        } label: {
          Text(title)
            .font(.system(size: 18))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.black)
        }
      }
    }
  }
  
  private func handleNotifyAction() {
    print("\(currentApplicant.applicantName)에게 알림 발송")
  }
  
  private func showConfirmationModal(for buttonType: ButtonType) {
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
  

  

  

}

enum ButtonType {
  case left
  case right
}

#Preview {
  BottomNavigationSection(
    viewModel: ApplicationManagementViewModel(),
    currentIndex: .constant(0),
    confirmationType: .constant(.reject("dd")), allApplicant: [Application(
      applicationId: UUID(),
      applicantUserId: "dd",
      postId: "dd",
      status: ApplicationStatus.submitted.rawValue,
      applicantName: "조재훈",
      postTitle: "ㅇㅇ",
      postOrganization: "ㅇㅇ",
      postAuthorUserId: "ㅇㅇ"
    )
    ],
    currentApplicant: Application(
      applicationId: UUID(),
      applicantUserId: "dd",
      postId: "dd",
      status: ApplicationStatus.submitted.rawValue,
      applicantName: "조재훈",
      postTitle: "ㅇㅇ",
      postOrganization: "ㅇㅇ",
      postAuthorUserId: "ㅇㅇ"
    ),
    currentApplicationStatus: ApplicationStatus(
      rawValue: ApplicationStatus.submitted.rawValue
    ) ?? .submitted
  )
}
