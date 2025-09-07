//
//  ExitSheetView.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import SwiftUI

struct ExitSheetView: View {
  
  let exitAction: () -> Void
  let keepAction: () -> Void
  
  var body: some View {
  VStack(alignment: .center) {
      content
        Spacer().frame(height: 40)
      ButtonView
    }
    .padding(.horizontal, 16.5)
  }
  
  private var content: some View {
      VStack {
          Text("지금까지 작성한 내용이 저장되지 않습니다.")
            .subheadline20SemiBold()
            .foregroundStyle(.grayblack)
            .padding(.top, 48)
          Text("나가시겠어요?")
            .subheadline20SemiBold()
            .foregroundStyle(.grayblack)
      }
  }
  
  private var ButtonView: some View {
    VStack(spacing: 24) {
      Button {
        exitAction()
      } label: {
        Text("제출하지 않고 나가기")
          .body1SemiBold18()
          .foregroundStyle(.graywhite)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14.5)
          .background(.primaryBlack)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      Button {
        keepAction()
      } label: {
        Text("계속 작성하기")
          .body1Medium18()
          .foregroundStyle(.gray600)
          .frame(maxWidth: .infinity)
          .background(.graywhite)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.bottom, 30)
  }
}

//#Preview {
//  ExitSheetView()
//}
