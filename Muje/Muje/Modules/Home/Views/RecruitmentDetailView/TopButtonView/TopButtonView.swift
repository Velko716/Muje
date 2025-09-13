//
//  TopButtonView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

struct TopButtonView: View {
  @State private var showReportModal: Bool = false
  
  let isAuthor: Bool
  let action: () -> Void
  
  let fixAction: () -> Void
  let reportAction: () -> Void
  let deleteAction: () -> Void
  
  var body: some View {
    VStack {
      HStack {
        backButton
        Spacer()
        DropButton
      }
      .padding(.horizontal, 16)
      .padding(.top, 80)
      Spacer()
    }
  }
  
  private var DropButton: some View {
    Button {
      showReportModal = true
    } label: {
        Image(.moreIcon)
            .foregroundStyle(.gray700)
    }
    .sheet(isPresented: $showReportModal) {
      ReportModalView(
        showReportModal: $showReportModal,
        isAuthor: isAuthor,
        fixAction: {
          fixAction()
          showReportModal = false
        },
        reportAction: reportAction,
        deleteAction: deleteAction
      )
      .presentationDetents(isAuthor ? [.fraction(0.32)] : [.fraction(0.25)])
      .presentationCornerRadius(20)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
  }
  
  private var backButton: some View {
    Button {
      action()
    } label: {
        Image(.che)
        .foregroundStyle(.gray700)
    }
    .padding(.leading, -8)
  }
}


#Preview {
  TopButtonView(
    isAuthor: true,
    action: {},
    fixAction: {},
    reportAction: {},
    deleteAction: {}
  )
}
