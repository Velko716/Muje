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
    .hvPadding(16, 4)
    .frame(maxWidth: .infinity)
    .background(
      Rectangle()
        .fill(Color.white)
        .shadow(radius: 3)
        .ignoresSafeArea(edges: .bottom)
    )
  }
  
  private var navigatorSection: some View {
    HStack {
      Button {
        viewModel.moveToPrevious()
      } label: {
        if viewModel.currentIndex <= 0 {
          Image(.chevronLeftInActive)
        } else {
          Image(.che)
        }
      }
      .disabled(viewModel.currentIndex <= 0)
      
      Spacer()
      
      Text("\(viewModel.currentApplicant.applicantName)")
        .body1SemiBold18()
        .foregroundStyle(.grayblack)
      Text("(\(viewModel.currentIndex + 1)/\(viewModel.allApplicants.count))")
        .body1Regular18()
        .foregroundStyle(.gray700)
      
      Spacer()
      
      Button {
        viewModel.moveToNext()
      } label: {
        if viewModel.currentIndex >= viewModel.allApplicants.count - 1 {
          Image(.chevronRightInActive)
        } else {
          Image(.chevronRightActive)
        }
      }
      .disabled(
        viewModel.currentIndex >= viewModel.allApplicants.count - 1
      )
    }
    .padding(.vertical, 4)
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
              .body1SemiBold18()
              .foregroundStyle(.accentRed)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(.gray50)
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
          Button {
            viewModel.showConfirmationModal(for: .right)
          } label: {
            Text(right)
              .body1SemiBold18()
              .foregroundStyle(.graywhite)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(.grayblack)
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
        }
        .padding(.vertical, 16)
      case .singleButton(let title):
        HStack {
          Button {
            viewModel.confirmationType = .notify(viewModel.currentApplicant.applicantName)
          } label: {
            Text(title)
              .body1SemiBold18()
              .foregroundStyle(.graywhite)
              .frame(maxWidth: .infinity)
              .padding(.vertical, 16)
              .background(Color.black)
              .background(.grayblack)
              .clipShape(RoundedRectangle(cornerRadius: 10))
          }
        }
        .padding(.vertical, 16)
      }
    }
  }
}

#Preview {
  NavigationStack {
    
    BottomNavigationSection(
      viewModel: ModalViewModel(
        managementViewModel: .preview,
        applicant: ApplicationManagementViewModel.preview.allApplicants.first!,
        allApplicants: ApplicationManagementViewModel.preview.allApplicants
      )
    )
  }
}
