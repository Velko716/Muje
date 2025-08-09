//
//  ExitSheetView.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import SwiftUI

struct ExitSheetView: View {
  var body: some View {
    VStack {
      content
      Spacer()
      ButtonView
    }
    .padding(.horizontal, 16)
  }
  
  private var content: some View {
    Text("지금까지 작성한 내용이 \n 저장되지 않습니다. \n 나가시겠습니까?")
      .font(.system(size: 24))
      .multilineTextAlignment(.center)
      .padding(.top, 44)
  }
  
  private var ButtonView: some View {
    VStack(spacing: 12) {
      Button {
        // 네비게이션 이동
      } label: {
        Text("제출하지 않고 나가기")
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 21)
          .background(Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      Button {
        // 네비게이션 이동
      } label: {
        Text("계속 작성하기")
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 21)
          .background(Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.bottom, 30)
  }
}

#Preview {
  ExitSheetView()
}
