//
//  ReportHistoryListItem.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import SwiftUI

struct ReportHistoryListItem: View {
    let title: String
    let content: String
    let date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(Font.pretendard(type: .semiBold, size: 16))
                    .foregroundStyle(Color.gray700)
                Spacer()
                Text(date.fullDateSlashString)
                    .font(Font.pretendard(type: .regular, size: 14))
                    .foregroundStyle(Color.gray500)
            }
            Spacer().frame(height: 8)
            Text(content)
                .font(Font.pretendard(type: .regular, size: 16))
                .foregroundStyle(Color.gray500)
        }
    }
}

#Preview {
    ReportHistoryListItem(title: "욕설 및 혐오표현", content: "저한테 욕설을 빈번하게 사용했어요", date: Date())
        .paddingH16()
}
