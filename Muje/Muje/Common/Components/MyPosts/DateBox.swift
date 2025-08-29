//
//  DateBox.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct DateBox: View {
    var title: String
    var startDate: Date?
    var endDate: Date?
    var isPost: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .foregroundStyle(Color.gray)
            if let start = startDate, let end = endDate {
                Text("\(start.shortDateString) ~ \(end.shortDateString)")
                    .foregroundStyle(Color.black)
            } else if isPost {
                Text("면접일정을 설정해야 합니다")
                    .foregroundStyle(Color.red)
            } else {
                Text("미정")
                    .foregroundStyle(Color.black)
            }
        }
    }
}

#Preview {
    DateBox(title: "모집기간", startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 7), isPost: true)
}
