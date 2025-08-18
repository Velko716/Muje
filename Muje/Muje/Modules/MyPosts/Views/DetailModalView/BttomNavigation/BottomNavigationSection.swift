//
//  BottomNavigationSection.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import SwiftUI

struct BottomNavigationSection: View {
  
  @Bindable var viewModel: ModalViewModel
  
  var body: some View {
    VStack {
      if $viewModel.allApplicants.count > 1 {
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
        viewModel.moveToPrevious()
      } label: {
        Image(systemName: "chevron.left")
          .font(.system(size: 16))
          .foregroundStyle(viewModel.currentIndex > 0 ? Color.black : Color.gray)
      }
      .disabled(viewModel.currentIndex <= 0)
      Spacer()
      Text(
        "\(viewModel.currentApplicant.applicantName) (\(viewModel.currentIndex + 1)/\(viewModel.allApplicants.count))"
      )
        .font(.system(size: 16))
        .foregroundStyle(Color.black)
      Spacer()
      Button {
        viewModel.moveToNext()
      } label: {
        Image(systemName: "chevron.right")
          .font(.system(size: 16))
          .foregroundStyle(
            viewModel.currentIndex < viewModel.allApplicants.count - 1 ? Color.black : Color.gray
          )
      }
      .disabled(
        viewModel.currentIndex >= viewModel.allApplicants.count - 1
      )
    }
    .padding(.vertical, 16)
  }
  
  private var bottomButtonSection: some View {
    VStack {
      modalButton(
        viewModel.currentApplicationStatus.modalButtonType
      )
    }
  }
  
  private func modalButton(_ type: DetailModalButtonType) -> some View {
    Group {
      switch type {
      case .twoButton(let left, let right):
        HStack(spacing: 16) {
          Button {
            viewModel.showConfirmationModal(for: .left)
          } label: {
            Text(left)
              .font(.system(size: 18))
              .foregroundStyle(Color.black)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(Color.gray)
          }
          Button {
            viewModel.showConfirmationModal(for: .right)
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
        HStack {
          Button {
            viewModel.confirmationType = .notify(viewModel.currentApplicant.applicantName)
          } label: {
            Text(title)
              .font(.system(size: 18))
              .foregroundStyle(Color.white)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(Color.black)
          }
        }
        .padding(.vertical, 16)
      }
    }
  }
}

#Preview {
  BottomNavigationSection(
    viewModel: ModalViewModel(
      managementViewModel: ApplicationManagementViewModel(),
      applicant: Application(
        applicationId: UUID(),
        applicantUserId: "dd",
        postId: "dd",
        status: ApplicationStatus.submitted.rawValue,
        applicantName: "dd",
        postTitle: "dd",
        postOrganization: "dd",
        postAuthorUserId: "dd"
      ),
      allApplicants: [Application(
        applicationId: UUID(),
        applicantUserId: "dd",
        postId: "dd",
        status: ApplicationStatus.submitted.rawValue,
        applicantName: "dd",
        postTitle: "dd",
        postOrganization: "dd",
        postAuthorUserId: "dd"
      )]
    )
  )
}
