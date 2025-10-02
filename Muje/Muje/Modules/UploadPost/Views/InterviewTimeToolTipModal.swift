//
//  Untitled.swift
//  Muje
//
//  Created by Hong on 9/27/25.
//

import SwiftUI

struct InterviewTimeToolTipModal {
  @Binding var closeModal: Bool
}

extension InterviewTimeToolTipModal: View {
  var body: some View {
    VStack {
      Spacer()
      Group {
        Text("면접 시간은 설정한 전체 시간을")
          .subheadline20SemiBold()
        Text("나누어 배정하는 단위입니다")
          .subheadline20SemiBold()
      }
      .foregroundStyle(Color.grayblack)
      Spacer()
      if #available(iOS 26, *) {
        Image(.interviewToolTipImage26)
          .resizable()
          .frame(width: 361, height: 94)
      } else {
        Image(.interviewTimeToolTip)
          .resizable()
          .frame(width: 361, height: 94)
      }
      Spacer()
      Button {
        closeModal = false
      } label: {
        Text("확인")
          .body1SemiBold18()
          .foregroundStyle(.graywhite)
          .frame(maxWidth: .infinity)
          .padding()
      }
      .background(Color.primaryBlack)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .padding()
      Spacer()
    }
  }
}
