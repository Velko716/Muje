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
                    .font(Font.system(size: 16, weight: .semibold)) // FIXME: - 폰트 수정
                    .foregroundStyle(Color.black) // FIXME: - 컬러 수정
                Spacer()
                Text(date.fullDateSlashString) // FIXME: -
                    .font(Font.system(size: 14)) // FIXME: - 폰트 수정
                    .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
            }
            Spacer().frame(height: 8)
            Text(content)
                .font(Font.system(size: 16)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
        }
    }
}

#Preview {
    ReportHistoryListItem(title: "욕설 및 혐오표현", content: "저한테 욕설을 빈번하게 사용했어요", date: Date())
        .paddingH16()
}
