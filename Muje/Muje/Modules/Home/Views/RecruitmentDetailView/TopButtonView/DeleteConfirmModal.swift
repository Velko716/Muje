//
//  DeleteConfirmModal.swift
//  Muje
//
//  Created by 조재훈 on 8/24/25.
//

import SwiftUI

struct DeleteConfirmModal: View {
  
  @Environment(\.dismiss) private var dismiss
  @Binding var showReportModal: Bool
  
  
  let deleteAciton: () -> Void
  
  var body: some View {
    VStack(spacing: 40) {
      textView
      deletebuttonView
    }
    .padding(.horizontal, 16)
  }
  
  private var textView: some View {
      VStack {
          Text("정말 공고를 삭제하시겠어요?")
              .subheadline20SemiBold()
              .foregroundStyle(.gray700)
          Text("삭제한 뒤에는 되돌릴 수 없어요.")
              .subheadline20SemiBold()
              .foregroundStyle(.gray700)
      }
  }
  
  private var deletebuttonView: some View {
      VStack(spacing: 24) {
      Button {
        showReportModal = false
        deleteAciton()
      } label: {
        Text("삭제")
          .body1SemiBold18()
          .foregroundStyle(.graywhite)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14.5)
          .background(.accentRed)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    
      Button {
        dismiss()
      } label: {
        Text("취소")
          .body1SemiBold18()
          .foregroundStyle(.gray600)
          .frame(maxWidth: .infinity)
          .background(Color.clear)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
  }
}

#Preview {
  DeleteConfirmModal(showReportModal: .constant(false), deleteAciton: {})
}
