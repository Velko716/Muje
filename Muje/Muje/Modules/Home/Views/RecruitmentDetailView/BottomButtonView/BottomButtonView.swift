//
//  BottomButtonView.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

struct BottomButtonView: View {
  var body: some View {
    HStack {
      Button {
        // 네비게이션 연결
      } label: {
        Text("문의하기")
          .font(.system(size: 18))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(Color.gray)
          .foregroundStyle(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      Button {
        // 네비게이션 연결
      } label: {
        Text("지원하기")
          .font(.system(size: 18))
          .frame(maxWidth: .infinity)
          .padding(.vertical, 16)
          .background(Color.gray)
          .foregroundStyle(.white)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.vertical, 53)
  }
}

#Preview {
  BottomButtonView()
}
