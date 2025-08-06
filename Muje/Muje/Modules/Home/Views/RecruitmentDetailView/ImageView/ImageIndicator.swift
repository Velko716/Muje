//
//  ImageIndicator.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

extension ImageView {
  var ImageIndicator: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Text("\(currentPage + 1) / \(sortedImageUrls.count)")
          .font(.caption)
          .fontWeight(.medium)
          .foregroundStyle(.white)
          .padding(.horizontal, 13)
          .padding(.vertical, 8)
          .background(
            Capsule()
              .fill(Color.black.opacity(0.2))
          )
      }
      .padding(.trailing, 16)
    }
    .padding(.bottom, 16)
  }
}
