//
//  DateSeparator.swift
//  Muje
//
//  Created by 김진혁 on 8/19/25.
//

import SwiftUI

struct DateSeparator: View {
    let date: Date
    var body: some View {
        HStack {
            Rectangle().fill(.secondary.opacity(0.2)).frame(height: 1)
            Text("\(date.fullDateWeekday(date))")
                .font(.caption).foregroundStyle(.secondary)
                .padding(.horizontal, 7)
                .fixedSize(horizontal: true, vertical: false)
            Rectangle().fill(.secondary.opacity(0.2)).frame(height: 1)
        }
        .padding(.bottom, 12)
    }
}


#Preview {
    DateSeparator(date: Date())
}
