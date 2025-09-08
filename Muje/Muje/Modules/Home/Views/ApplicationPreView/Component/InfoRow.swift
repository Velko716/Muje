//
//  InfoRow.swift
//  Muje
//
//  Created by 조재훈 on 8/10/25.
//

import SwiftUI

struct InfoRow: View {
  let title: String
  let value: String

  var body: some View {
    HStack {
      Text(title)
        .body1Regular16()
        .foregroundStyle(.gray500)
      Spacer().frame(width: 16)
      Text(value)
            .body1Medium16()
            .foregroundStyle(.gray700)
    Spacer()
    }
    .padding(.horizontal, 16)
  }
}

