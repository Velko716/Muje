//
//  ImageIndicator.swift
//  Muje
//
//  Created by 조재훈 on 8/7/25.
//

import SwiftUI

extension ImageView {
    var ImageIndicator: some View {
        HStack(spacing: 0) {
            Text("\(currentPage + 1)")
                .caption14SemiBold()
                .foregroundStyle(.white)
            Text(" /\(sortedImageUrls.count)")
                .caption14Regular()
                .foregroundStyle(.gray200)
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 13)
        .background(
            Capsule()
                .fill(.statusOpacity20)
        )
    }
}
