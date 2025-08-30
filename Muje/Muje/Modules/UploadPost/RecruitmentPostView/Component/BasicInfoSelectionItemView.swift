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
          .font(.system(size: 16))
          .foregroundStyle(isChecked ? Color.blue : Color.gray)
        Spacer()
        Circle()
          .strokeBorder(Color.gray.opacity(0.2))
          .frame(width: 26, height: 26)
          .overlay(
            text == "지원자 이름"
            ? Image(.essentialCircle)
            : (isChecked ? Image(.checkCircle) : nil)
          )
        
      } //: HSTACK
      .frame(maxWidth: .infinity)
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
      .background (
        RoundedRectangle(cornerRadius: 10)
          .stroke(isChecked ? Color.blue : Color.gray, lineWidth: 1)
          .fill(isChecked ? Color.blue.opacity(0.2) : Color.clear)
      )
    }
  }
}
