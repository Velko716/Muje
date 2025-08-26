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
            Color.white
            VStack {
                reportListItemView(viewModel.reports)
                Spacer()
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
    
    // MARK: - 리스트 뷰 분기처리
    @ViewBuilder
    func reportListItemView(_ reports: [Report]) -> some View {
        switch reports.isEmpty {
        case true:
            emptyReportListView
        case false:
            reportListView
        }
    }
    
    
    // MARK: - 신고 리스트 뷰 (데이터가 존재 하지 않을때)
    private var emptyReportListView: some View {
        VStack {
            Spacer().frame(height: 48) // FIXME: - 수정
            Text("신고 내역이 없어요")
                .font(Font.system(size: 16, weight: .semibold)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
        } //: VSTACK
        .frame(maxWidth: .infinity)
        .frame(height: 48)
    }
    
    
    // MARK: - 신고 리스트 뷰 (데이터 1개 이상일 때)
    private var reportListView: some View {
        List {
            ForEach(viewModel.reports, id: \.reportId) { row in
                ReportHistoryListItem(
                    title: row.reportType.description,
                    content: row.reason ?? "",
                    date: row.createdAt?.dateValue() ?? Date()
                )
            }
        }
    }
    
    
    // MARK: - 바텀) 신고 생성 테스트 버튼 (삭제 예정)
    private var createReportTestButtonView: some View {
        Button {
            Task {
                await viewModel.createReportTestButtonTapped()
            }
        } label: {
            Text("테스트 버튼")
                .font(Font.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.black)
        }
        .background(Color.blue)
    }
    
    
}

#Preview {
    NavigationStack {
        ReportsHistoryView()
    }
}
