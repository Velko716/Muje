//
//  DateSeparator.swift
//  Muje
//
//  Created by 김진혁 on 8/19/25.
//

import SwiftUI

/// 날짜 구분선 컴포넌트 입니다
struct DateSeparator: View {
    let date: Date
    var body: some View {
        HStack {
            Rectangle().fill(Color.gray400).frame(height: 0.5)
            Spacer()
            Text("\(date.fullDateWeekday(date))")
                .font(Font.pretendard(type: .medium, size: 12))
                .foregroundStyle(Color.gray400)
                .fixedSize(horizontal: true, vertical: false)
            Spacer()
            Rectangle().fill(Color.gray400).frame(height: 0.5)
        }
        .padding(.bottom, 12)
    }
}


#Preview {
    DateSeparator(date: Date())
        .padding(.horizontal, 16)
}
