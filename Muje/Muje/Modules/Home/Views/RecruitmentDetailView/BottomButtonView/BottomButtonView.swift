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
          .body1SemiBold18()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14.5)
          .padding(.horizontal, 55)
          .background(.gray50)
          .foregroundStyle(.gray700)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      Button {
        applicationAction()
      } label: {
        Text(hasApplied ? "지원완료" : "신청하기")
          .body1SemiBold18()
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14.5)
          .padding(.horizontal, 55)
          .background(hasApplied ? .gray200 : .primaryBlack)
          .foregroundStyle(hasApplied ? .gray400 : .graywhite)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .disabled(hasApplied)
    }
    .padding(EdgeInsets(top: 20, leading: 16, bottom: 43, trailing: 16))
    .background(
        Rectangle()
            .fill(.white)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -4)
            .ignoresSafeArea(.all, edges: .bottom)
    )
  }
}

#Preview {
  BottomButtonView(hasApplied: true, applicationAction: {}, contactAction: {})
}
