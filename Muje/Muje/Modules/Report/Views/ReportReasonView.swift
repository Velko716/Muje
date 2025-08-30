//
//  ReportReasonView.swift
//  Muje
//
//  Created by 김진혁 on 8/29/25.
//

import SwiftUI

// MARK: - 신고하기 - 사유 선택 뷰
struct ReportReasonView: View {
    @Bindable var viewModel: ReportViewModel
    @Binding var showReportSheet: Bool
    
    var body: some View {
        VStack {
            topTitle
                .paddingH16()
            Spacer().frame(height: 32)
            middleListView
        }
    }
    
    // MARK: - 탑 타이틀
    private var topTitle: some View {
        Text("신고사유를 선택해주세요")
            .font(Font.system(size: 22, weight: .semibold)) // FIXME: - 폰트 수정
            .foregroundStyle(Color.black) // FIXME: - 컬러 수정
    }
    
    // MARK: - 중간 리스트
    private var middleListView: some View {
        List {
            ForEach(viewModel.reportRow) { row in
                NavigationLink {
                    ReportDetailView(
                        viewModel: viewModel,
                        showReportSheet: $showReportSheet
                    )
                        .hideBackButton()
                        .onAppear { viewModel.selectedReason = row.content }
                } label: {
                    Text(row.title)
                        .padding(.vertical, 16)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ReportReasonView(viewModel: ReportViewModel(), showReportSheet: .constant(false))
    }
}
