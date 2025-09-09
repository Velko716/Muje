//
//  CompleteReportView.swift
//  Muje
//
//  Created by 김진혁 on 8/29/25.
//

import SwiftUI

// MARK: - 신고하기 - 완료 뷰
// TODO: 신고를 처리하는 로직을 만들어야 함. (ex. 이메일 전송, 파이어베이스 저장 등등)
struct CompleteReportView: View {
    @Bindable var viewModel: ReportViewModel
    @Binding var showReportSheet: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("신고가 접수 되었어요")
                    .font(Font.pretendard(type: .semiBold, size: 22))
                    .foregroundStyle(Color.gray700)
                
                Spacer().frame(height: 16)
                
                Text("접수된 신고는 빠르고 신중하게 처리하겠습니다.\n감사합니다.")
                    .font(Font.pretendard(type: .regular, size: 16))
                    .foregroundStyle(Color.gray500)
                    .lineSpacing(6)
                
                // TODO: 그래픽 추가하기
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .paddingH16()
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                ReportsHistoryView()
                    .hideBackButton()
            } label: {
                VStack {
                    BottomBar(
                        text: "신고 내역 보기",
                        textColor: Color.gray50,
                        bgColor: Color.primaryBlack,
                        enabled: true
                    ) {}
                }
            }
            .bottomBarBackground()
            .padding(.bottom, 8) // FIXME: - 논의 필요
        }
        .task {
            await viewModel.createReport(
                reportedUserId: viewModel.reportedUserId ?? "",
                conversationId: viewModel.conversationId ?? ""
            )
        }
        .toolbar {
            ToolbarLeadingXmarkBackButton { showReportSheet = false }
            ToolbarCenterTitle(text: "신고하기")
        }
    }
}

#Preview {
    NavigationStack {
        CompleteReportView(viewModel: ReportViewModel(), showReportSheet: .constant(false))
    }
}
