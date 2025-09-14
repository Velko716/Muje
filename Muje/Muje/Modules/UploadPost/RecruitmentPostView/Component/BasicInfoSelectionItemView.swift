//
//  BasicInfoSelectionItemView.swift
//  Muje
//
//  Created by 김서현 on 8/24/25.
//

import SwiftUI

struct BasicInfoSelectionItemView: View {
  
  let field: RecruitmentField
  let text: String
  let isChecked: Bool
  let toggle: () -> Void
  @FocusState var IsTyping: Bool
  
  var body: some View {
    
    Button {
      if field != .name {
        toggle()
      }
    } label: {
      HStack {
        Text(text)
          .body2Medium16()
          .foregroundStyle(isChecked ? .pointSkyBlue : .gray500)
        Spacer()
        Circle()
          .strokeBorder(.gray200)
          .frame(width: 26, height: 26)
          .overlay(
            text == "지원자 이름"
            ? Image(.essentialCircle)
            : (isChecked ? Image(.checkCircle) : nil)
          )
        
      } //: HSTACK
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 16)
      .padding(.vertical, 14)
      .background (
        RoundedRectangle(cornerRadius: 10)
            .stroke(isChecked ? .pointSkyBlue : .gray100, lineWidth: 1)
            .fill(isChecked ? .pointSkyBlueTinted : Color.clear)
      )
    }
  }
}
