//
//  InfoTag.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import SwiftUI

struct InfoTag: View {
  let title: String
  let isActive: Bool
  
  var body: some View {
    Text(title)
      .fontWeight(.medium)
      .foregroundStyle(isActive ? .primary : .secondary)
      .padding(.vertical, 9)
      .padding(.horizontal, 15)
      .background(
        RoundedRectangle(
          cornerRadius: 100
        )
        .stroke(
          isActive ? Color.primary : Color.secondary.opacity(0.3),
          lineWidth: 1
        )
        .background(
          RoundedRectangle(
            cornerRadius: 100
          )
          .fill(
            isActive ? Color.gray.opacity(0.4) : Color(
              Color.clear
            )
          )
        )
      )
  }
}

#Preview {
  InfoTag(title: "학과 / 전공", isActive: true)
}
