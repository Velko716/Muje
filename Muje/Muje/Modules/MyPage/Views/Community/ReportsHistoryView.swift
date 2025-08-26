//
//  ReportsHistory.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import SwiftUI

struct ReportsHistoryView: View {
    var body: some View {
        ZStack {
            VStack {
                
            }
        }
        .toolbar {
            ToolbarLeadingBackButton() // FIXME: - 버튼 이미지?
            ToolbarCenterTitle(text: "신고 내역")
        }
    }
}

#Preview {
    NavigationStack {
        ReportsHistoryView()
    }
}
