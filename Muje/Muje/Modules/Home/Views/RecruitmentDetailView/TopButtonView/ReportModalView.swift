//
//  ReportModalView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

struct ReportModalView: View {
  
  @EnvironmentObject var router: NavigationRouter
  
  @Binding var showReportModal: Bool
  @State private var showDeleteModal: Bool = false
  
  let isAuthor: Bool
  let fixAction: () -> Void
  let reportAction: () -> Void
  let deleteAction: () -> Void
  
  var body: some View {
    VStack {
      if isAuthor {
          VStack(alignment: .center, spacing: 16) {
              postFixButton
              Divider()
                  .padding(.horizontal, 18.5)
                  .foregroundStyle(.gray300)
              deleteButton
          }
          .padding(.vertical, 18)
          .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray50)
          )
        dismissButton
      } else {
        reportButton
        dismissButton
      }
    }
    .padding(.horizontal, 16)
    .sheet(isPresented: $showDeleteModal) {
      DeleteConfirmModal(showReportModal: $showReportModal, deleteAciton: deleteAction)
        .presentationDetents([.fraction(0.4)])
        .presentationCornerRadius(20)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
  }
  
  private var postFixButton: some View {
    Button {
      fixAction()
    } label: {
        HStack(spacing: 3.5) {
        Image(.penIcon)
            .resizable()
            .frame(width: 20, height: 20)
        Text("수정하기")
            .body1SemiBold18()
            .foregroundStyle(.gray700)
      }
      .frame(maxWidth: .infinity)
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private var deleteButton: some View {
    Button {
      showDeleteModal = true
    } label: {
        HStack(spacing: 3.5) {
        Image(.trashIcon)
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundStyle(.accentRed)
        Text("삭제하기")
          .body1SemiBold18()
          .foregroundStyle(.accentRed)
      }
      .frame(maxWidth: .infinity)
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private var reportButton: some View {
    Button {
      reportAction()
    } label: {
      HStack {
        Image(.reportIcon)
        Text("신고하기")
            .body1SemiBold18()
      }
      .padding(.vertical, 15.5)
      .frame(maxWidth: .infinity)
      .foregroundStyle(.accentRed)
      .background(.gray50)
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private var dismissButton: some View {
    Button {
      showReportModal = false
    } label: {
      Text("닫기")
        .foregroundStyle(.gray500)
        .body1Medium18()
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  ReportModalView(
    showReportModal: .constant(true),
    isAuthor: true,
    fixAction: {},
    reportAction: {},
    deleteAction: {}
  )
}
