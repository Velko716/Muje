//
//  TwoActionBottomButton.swift
//  Muje
//
//  Created by 김서현 on 9/6/25.
//

import SwiftUI

struct TwoActionBottomButton: View {
    var leftAction: () -> Void
    var leftText: String
    var leftBGColor: Color = .gray50
    var rightAction: () -> Void
    var rightText: String
    var rightBGColor: Color = .primaryBlack
    var body: some View {
        HStack(spacing: 17) {
            Button {
                leftAction()
            } label: {
                Text(leftText)
                    .body1SemiBold18()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(leftBGColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Button {
                rightAction()
            } label: {
                Text(rightText)
                    .body1SemiBold18()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(rightBGColor)
                    .foregroundStyle(.white01)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 43, trailing: 16))
        .background(
            Rectangle()
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -4)
                .ignoresSafeArea(.all, edges: .bottom)
        )
    }
}
