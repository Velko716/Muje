//
//  ReportModalView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

struct ReportModalView: View {
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    VStack {
      reportButton
      dismissButton
    }
    .padding(.horizontal, 16)
  }
  
  private var reportButton: some View {
    Button {
      //
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
      dismiss()
    } label: {
      Text("닫기")
        .foregroundStyle(.gray)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  ReportModalView()
}
