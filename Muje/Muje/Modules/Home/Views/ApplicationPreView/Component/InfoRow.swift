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
        .frame(width: 60, alignment: .leading)
      
      Text(value)
      
      Spacer()
    }
  }
}

