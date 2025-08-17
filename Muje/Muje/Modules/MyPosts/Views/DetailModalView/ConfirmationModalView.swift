//
//  BottomModalView.swift
//  Muje
//
//  Created by 조재훈 on 8/17/25.
//

import SwiftUI

struct ConfirmationModalView: View {
  
  @Environment(\.dismiss) private var dismiss
  
//  let title: String
  let type: ConfirmationModalType
  let onConfirm: () -> Void
  
  var body: some View {
    VStack {
      titleSection
      buttonSection
    }
  }
  
  private var titleSection: some View {
    VStack {
      Text(type.title)
        .multilineTextAlignment(.center)
    }
  }
  
  private var buttonSection: some View {
    VStack {
      Button {
        onConfirm()
      } label: {
        Text(type.buttonText)
          .font(.system(size: 16))
          .foregroundStyle(Color.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(confirmButtonColor)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      Button {
        dismiss()
      } label: {
        Text("취소")
          .font(.system(size: 16))
          .foregroundStyle(Color.gray)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.horizontal, 16)
  }
  
  private var confirmButtonColor: Color {
    switch type {
    case .reject, .cancelInterview:
      return Color.red
    case .promote, .pass, .completeInterview:
      return Color.black
    case .notify:
      return Color.gray
    }
  }
}

#Preview {
  ConfirmationModalView(type: ConfirmationModalType.reject("dd"), onConfirm: {})
}
