//
//  PostCreateButton.swift
//  Muje
//
//  Created by 김서현 on 8/17/25.
//

import SwiftUI

struct PostCreateButton: View {
    var body: some View {
        Button {
            // Post 만드는 화면으로 이동
        } label: {
            HStack {
                Text("모임 올리기")
                    .foregroundStyle(Color.white)
                Image(systemName: "pencil")
                    .foregroundStyle(Color.white)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background {
                RoundedRectangle(cornerRadius: 36)
                    .fill(Color.blue)
            }
        }

    }
}
