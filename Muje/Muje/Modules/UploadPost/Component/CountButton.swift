//
//  CountButton.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI

struct CountButton: View {
  @State private var showModal = false
  @Binding var value: Int
  
  var title: String
  var subTitle: String
  var count: Int
  var unit: String
  var condition: Bool?
  
  var body: some View {
    HStack {
      VStack {
        HStack(spacing: 0) {
          Text(title)
            .body1SemiBold18()
            .foregroundStyle(.gray700)
//            .frame(maxWidth: .infinity, alignment: .leading)
          if title == "면접 시간" {
            Image(.iconInformation)
              .padding(.leading, 4)
              .onTapGesture {
                showModal = true
              }
          }
          Spacer()
        }
        Text(subTitle)
          .caption14Medium()
          .foregroundStyle(.gray600)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      Spacer()
      HStack {
        Button(action: {
          self.value -= count
        }, label: {
          if ((value - count) <= 0) {
            Image(.iconRemoveInactive)
          } else {
            Image(.iconRemovepdf)
          }
        })
        .disabled((value - count) <= 0)
        .padding(.leading, 18)
        Spacer()
        Text("\(value)\(unit)")
        Spacer()
        Button(action: {
          self.value += count
        }, label: {
          if condition ?? false {
//            Image(.iconAddActive)
            Image(.iconAddInActive)
          } else {
            Image(.iconAddpdf)
          }
        })
        .disabled(condition ?? false)
        .padding(.trailing, 18)
      }
      .frame(maxWidth: 154, minHeight: 44)
      .background(Color.gray50)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .sheet(isPresented: $showModal) {
        InterviewTimeToolTipModal(closeModal: $showModal)
          .presentationDetents([.medium])
      }
    }
  }
}

#Preview {
  CountButton(value: .constant(1), title: "qwer", subTitle: "응애", count: 2, unit: "SS")
}
