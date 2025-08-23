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
  
  var body: some View {
    VStack {
      HStack {
        backButton
        Spacer()
        DropButton
      }
      .padding(.horizontal, 16)
      .padding(.top, 100)
      Spacer()
    }
    
    private var DropButton: some View {
        Button {
            showReportModal = true
        } label: {
            Image(systemName: "text.append")
        }
        .sheet(isPresented: $showReportModal) {
            ReportModalView(showReportModal: $showReportModal)
                .presentationDetents([.fraction(0.2)])
                .presentationCornerRadius(20)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    .sheet(isPresented: $showReportModal) {
      ReportModalView(
        showReportModal: $showReportModal,
        isAuthor: isAuthor,
        fixAction: fixAction,
        reportAction: reportAction
      )
        .presentationDetents(isAuthor ? [.fraction(0.32)] : [.fraction(0.25)])
        .presentationCornerRadius(20)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
  TopButtonView(
    isAuthor: true,
    action: {},
    fixAction: {},
    reportAction: {}
  )
}
