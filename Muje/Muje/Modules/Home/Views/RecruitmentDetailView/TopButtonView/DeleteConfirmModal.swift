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
    Text("정말 공고를 삭제하시겠어요?\n삭제한 뒤에는 되돌릴 수 없어요.")
      .multilineTextAlignment(.center)
  }
  
  private var deletebuttonView: some View {
    VStack {
      Button {
        showReportModal = false
        deleteAciton()
        
        
      } label: {
        Text("삭제")
          .font(.system(size: 18))
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 18)
          .background(Color.red)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      
      Button {
        dismiss()
      } label: {
        Text("취소")
          .font(.system(size: 18))
          .foregroundStyle(.black)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 18)
          .background(Color.clear)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
  }
}

#Preview {
  DeleteConfirmModal(showReportModal: .constant(false), deleteAciton: {})
}
