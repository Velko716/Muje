//
//  BlockHistoryListItem.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import SwiftUI

struct BlockHistoryListItem: View {
    let blockedName: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(blockedName)
                .font(Font.pretendard(type: .semiBold, size: 16))
                .foregroundStyle(Color.gray700)
            Spacer()
            Button(action: action) {
                Text("차단 해제")
                    .font(Font.pretendard(type: .semiBold, size: 16))
                    .foregroundStyle(Color.accentRed)
                    .frame(width: 92)
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray50)
                    )
            }
            .frame(width: 92)
            .frame(height: 40)
            .buttonStyle(.plain)
            .contentShape(Rectangle())
        }
        .padding(.vertical, 8)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    BlockHistoryListItem(blockedName: "제이콥") {
        print("차단 해제")
    }
    .paddingH16()
}
