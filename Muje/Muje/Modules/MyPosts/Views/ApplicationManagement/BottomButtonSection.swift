//
//  BottomButtonSection.swift
//  Muje
//
//  Created by 조재훈 on 8/16/25.
//

import Foundation
import SwiftUI

extension ApplicationManagementView {
  var bottomButtonj: some View {
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
    //    .animation(.none, value: viewModel.selectedTab)
    //    .animation(.none, value: viewModel.selectedManagementStage)
    //    .animation(.none, value: viewModel.isSelectionMode)
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(Color(.systemBackground))
  }
  
  private var leftButton: String {
    switch viewModel.selectedManagementStage {
    case .submitted:
      return "불합격"
    case .interviewWaiting:
      return "면접 취소"
    case .reviewWaiting:
      return "불합격"
    case .reviewCompleted:
      return "모두에게 심사 결과 알리기"
    }
  }
  
  private var rightButton: String {
    switch viewModel.selectedManagementStage {
    case .submitted:
      return "면접 제안"
    case .interviewWaiting:
      return "면접 완료"
    case .reviewWaiting:
      return "합격"
    case .reviewCompleted:
      return "모두에게 심사 결과 알리기"
    }
  }
  
  private var notifyButton: some View {
    Button {
      //
    } label: {
      Text("dd")
        .font(.system(size: 18))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .foregroundStyle(.white)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private func notifyButtons(_ type: NotifyButtonType) -> some View {
    Button {
      //
    } label: {
      Text(type.dispayName)
        .font(.system(size: 18))
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .foregroundStyle(.white)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private func processButton(_ type: buttonType) -> some View {
    HStack {
      Button {
        viewModel.handleLeftButtonAction()
      } label: {
        Text(type.LeftDisplayName)
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .foregroundStyle(.white)
          .background(Color.red)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .disabled(viewModel.selectedApplicantId.isEmpty)
      .opacity(viewModel.selectedApplicantId.isEmpty ? 0.5 : 1.0)
      
      Button {
        viewModel.handleRightButtonAction()
      } label: {
        Text(type.RightDisplayName)
          .font(.system(size: 18))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .foregroundStyle(.white)
          .background(Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .disabled(viewModel.selectedApplicantId.isEmpty)
      .opacity(viewModel.selectedApplicantId.isEmpty ? 0.5 : 1.0)
    }
    //    .padding(.horizontal, 16)
    //    .padding(.vertical, 12)
    //    .background(Color(.systemBackground))
  }
  
  
  enum buttonType: String {
    case submitted
    case interviewWaiting
    case reviewWaiting
    
    var LeftDisplayName: String {
      switch self {
      case .submitted:
        return "불합격"
      case .interviewWaiting:
        return "면접 취소"
      case .reviewWaiting:
        return "불합격"
      }
    }
    
    var RightDisplayName: String {
      switch self {
      case .submitted:
        return "면접 제안"
      case .interviewWaiting:
        return "면접 완료"
      case .reviewWaiting:
        return "합격"
      }
    }
  }
  
  enum NotifyButtonType: String {
    case allNotify
    case selectedNotify
    
    var dispayName: String {
      switch self {
      case .allNotify:
        return "모두에게 심사 결과 알리기"
      case .selectedNotify:
        return "심사 결과 알리기"
      }
    }
  }
  
  
}
