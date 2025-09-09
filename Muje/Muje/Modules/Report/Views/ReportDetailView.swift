//
//  ReportDetailView.swift
//  Muje
//
//  Created by 김진혁 on 8/29/25.
//

import SwiftUI

// MARK: - 신고하기 - 텍스트 필드 뷰
struct ReportDetailView: View {
    @Bindable var viewModel: ReportViewModel
    @Binding var showReportSheet: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("상세 내용을 작성해주세요")
                    .font(Font.pretendard(type: .semiBold, size: 22))
                    .foregroundStyle(Color.gray700)
                
                Spacer().frame(height: 27)
                
                PlaceholderTextEditor(
                    text: $viewModel.detailText,
                    placeholder: "신고 내용을 상세하게 적어주세요"
                )
                Spacer()
            }
        }
        .paddingH16()
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                CompleteReportView(
                    viewModel: viewModel,
                    showReportSheet: $showReportSheet
                )
                .hideBackButton()
            } label: {
                VStack {
                    BottomBar(
                        text: "신고하기",
                        textColor: Color.gray50,
                        bgColor: Color.accentRed,
                        enabled: !viewModel.detailText.isEmpty
                    ) {}
                        .environment(\.isEnabled, false) // TODO: 코드 논의
                }
            }
            .disabled(viewModel.detailText.isEmpty)
            .bottomBarBackground()
            .padding(.bottom, 8) // FIXME: - 논의 필요
        }
        .dismissKeyboardOnTap()
        .toolbar {
            ToolbarLeadingXmarkBackButton { showReportSheet = false }
            ToolbarCenterTitle(text: "신고하기")
        }
    }
}

#Preview {
    NavigationStack {
        ReportDetailView(viewModel: ReportViewModel(), showReportSheet: .constant(false))
    }
}

