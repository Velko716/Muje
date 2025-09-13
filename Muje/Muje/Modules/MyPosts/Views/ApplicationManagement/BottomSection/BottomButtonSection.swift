//
//  BottomButtonSection.swift
//  Muje
//
//  Created by 조재훈 on 8/16/25.
//

import Foundation
import SwiftUI

extension ApplicationManagementView {
  var bottomButton: some View {
    HStack {
      if viewModel.selectedManagementStage == .reviewCompleted && !viewModel.isSelectionMode {
        notifyButtons(NotifyButtonType.allNotify)
      } else if viewModel.selectedManagementStage == .reviewCompleted && viewModel.isSelectionMode {
        notifyButtons(NotifyButtonType.selectedNotify)
      } else if viewModel.selectedManagementStage == .submitted && viewModel.isSelectionMode {
        processButton(.submitted)
      } else if viewModel.selectedManagementStage == .interviewWaiting && viewModel.isSelectionMode {
        processButton(.interviewWaiting)
      } else if viewModel.selectedManagementStage == .reviewWaiting && viewModel.isSelectionMode {
        processButton(.reviewWaiting)
      }
    }
    .transaction { transaction in
      transaction.disablesAnimations = true
    }
  }
  
  private func notifyButtons(_ type: NotifyButtonType) -> some View {
    Button {
      // TODO: 심사 결과 알림
    } label: {
      Text(type.dispayName)
        .body1SemiBold18()
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .foregroundStyle(.graywhite)
        .background(.primaryBlack)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    .hvPadding(16, 20)
    .frame(maxWidth: .infinity)
    .background(
      Rectangle()
        .fill(Color.white)
        .shadow(radius: 3)
        .ignoresSafeArea(edges: .bottom)
    )
  }
  
  private func processButton(_ type: ManagementButtonType) -> some View {
    HStack {
      Button {
        viewModel.handleLeftButtonAction()
      } label: {
        Text(type.LeftDisplayName)
          .body1SemiBold18()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .foregroundStyle(.gray700)
          .background(.gray50)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .disabled(viewModel.selectedApplicantId.isEmpty)
      .opacity(viewModel.selectedApplicantId.isEmpty ? 0.5 : 1.0)
      
      Button {
        viewModel.handleRightButtonAction()
      } label: {
        Text(type.RightDisplayName)
          .body1SemiBold18()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .foregroundStyle(.graywhite)
          .background(.primaryBlack)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .disabled(viewModel.selectedApplicantId.isEmpty)
      .opacity(viewModel.selectedApplicantId.isEmpty ? 0.5 : 1.0)
    }
    .hvPadding(16, 20)
    .frame(maxWidth: .infinity)
    .background(
      Rectangle()
        .fill(Color.white)
        .shadow(radius: 3)
        .ignoresSafeArea(edges: .bottom)
    )
  }
}
