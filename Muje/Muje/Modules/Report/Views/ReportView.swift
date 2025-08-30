//
//  ReportView.swift
//  Muje
//
//  Created by 김진혁 on 8/28/25.
//

import SwiftUI

struct ReportView: View {
    @State private var viewModel: ReportViewModel = .init()
    @Binding var showReportSheet: Bool
    
    // FIXME: - 임시 (신고 변수)
    var reportedUserId: String?
    var conversationId: String?
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                VStack(alignment: .leading) {
                    ReportReasonView(
                        viewModel: viewModel,
                        showReportSheet: $showReportSheet
                    )
                }
            }
            .task {
                guard let reportedUserId = reportedUserId,
                        let conversationId = conversationId
                else { return }
                
                viewModel.reportedUserId = reportedUserId
                viewModel.conversationId = conversationId
            }
            .toolbar {
                ToolbarLeadingXmarkBackButton { showReportSheet = false }
                ToolbarCenterTitle(text: "신고하기")
            }
        }
    }
}


#Preview {
    NavigationStack {
        ReportView(showReportSheet: .constant(false))
    }
}
