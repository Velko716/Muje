//
//  BottomButtonView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

struct BottomButtonView: View {
  
  let hasApplied: Bool
  let applicationAction: () -> Void
  let contactAction: () -> Void
  
  var body: some View {
    HStack {
      Button {
        contactAction()
      } label: {
        Text("문의하기")
          .font(.system(size: 18))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(Color.black)
          .foregroundStyle(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      Button {
        applicationAction()
      } label: {
        Text(hasApplied ? "지원완료" : "지원하기")
          .font(.system(size: 18))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(hasApplied ? Color.gray.opacity(0.5) : Color.black)
          .foregroundStyle(hasApplied ? .gray : .white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .disabled(hasApplied)
    }
    .padding(.vertical, 53)
  }
}

#Preview {
  BottomButtonView(hasApplied: true, applicationAction: {}, contactAction: {})
}
