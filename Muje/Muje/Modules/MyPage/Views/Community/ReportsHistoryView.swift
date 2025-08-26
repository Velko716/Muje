//
//  ReportsHistory.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import SwiftUI

struct ReportsHistoryView: View {
    @State private var viewModel: ReportsHistoryViewModel = .init()
    
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(viewModel.reports, id: \.reportId) { row in
                        ReportHistoryListItem(
                            title: row.reportType.description,
                            content: row.reason ?? "",
                            date: row.createdAt?.dateValue() ?? Date()
                        )
                    }
                }
                createReportTestButtonView
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            await viewModel.loadReportData()
            print("reports :\(viewModel.reports)")
        }
        .toolbar {
            ToolbarLeadingBackButton() // FIXME: - 버튼 이미지?
            ToolbarCenterTitle(text: "신고 내역")
        }
    }
    
    
    // MARK: - 바텀) 신고 생성 테스트 버튼 (삭제 예정)
    private var createReportTestButtonView: some View {
        VStack {
            Button {
                Task {
                    await viewModel.createReportTestButtonTapped()
                }
            } label: {
                Text("테스트 버튼")
            }
            .background(Color.blue)
        }
    }
    
    
}

#Preview {
    NavigationStack {
        ReportsHistoryView()
    }
}
