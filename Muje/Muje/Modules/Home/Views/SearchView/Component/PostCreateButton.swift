//
//  PostCreateButton.swift
//  Muje
//
//  Created by 김서현 on 8/17/25.
//

import SwiftUI

struct PostCreateButton: View {
  let action: () -> Void
    var body: some View {
        Button {
          action()
        } label: {
            HStack {
                Text("모임 올리기")
                    .body2Medium16()
                    .foregroundStyle(.white)
                Image(.pencilIcon)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background {
                RoundedRectangle(cornerRadius: 36)
                    .fill(.pointSkyBlue)
                    .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 0)
            }
        }

    }
}
