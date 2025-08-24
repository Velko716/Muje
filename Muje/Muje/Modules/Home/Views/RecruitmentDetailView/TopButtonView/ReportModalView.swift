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
        postFixButton
        deleteButton
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
      HStack {
        Image(systemName: "pencil")
        Text("수정하기")
      }
      .padding(.vertical, 18)
      .frame(maxWidth: .infinity)
      .foregroundStyle(.red)
      .background(Color.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private var deleteButton: some View {
    Button {
      showDeleteModal = true
    } label: {
      HStack {
        Image(systemName: "light.beacon.min.fill")
        Text("삭제하기")
      }
      .padding(.vertical, 18)
      .frame(maxWidth: .infinity)
      .foregroundStyle(.red)
      .background(Color.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private var reportButton: some View {
    Button {
      reportAction()
    } label: {
      HStack {
        Image(systemName: "light.beacon.min.fill")
        Text("신고하기")
      }
      .padding(.vertical, 18)
      .frame(maxWidth: .infinity)
      .foregroundStyle(.red)
      .background(Color.gray.opacity(0.2))
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }
  
  private var dismissButton: some View {
    Button {
      showReportModal = false
    } label: {
      Text("닫기")
        .foregroundStyle(.gray)
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
