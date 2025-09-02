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
    var hasInterview: Bool?
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .foregroundStyle(Color.gray)
            if hasInterview == false {
                Text("없음")
                    .foregroundStyle(Color.black)
            } else {
                if let start = startDate, let end = endDate {
                    Text("\(start.dateString) ~ \(end.dateString)")
                        .foregroundStyle(Color.black)
                } else if let start = startDate, endDate == nil {
                    Text("\(start.dateString) - \(start.hourMinute24)")
                } else {
                    Text(isPost ? "면접일정을 설정해주세요" : "미정")
                        .foregroundStyle(isPost ? Color.red : Color.black)
                }
            }
        }
    }}

#Preview {
    DateBox(title: "모집기간", startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 7), isPost: true, hasInterview: true)
}
