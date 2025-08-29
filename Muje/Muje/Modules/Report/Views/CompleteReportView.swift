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
    
    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("신고가 접수 되었어요")
                        .font(Font.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.black)
                    
                    Spacer().frame(height: 16)
                    
                    Text("접수된 신고는 빠르고 신중하게 처리하겠습니다.\n감사합니다.")
                        .font(Font.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.gray)
                        .lineSpacing(6)
                    
                    // TODO: 그래픽 추가하기
                    Spacer()
                }
                Spacer()
            }
            // FIXME: - 컴포넌트로 대체 하기
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 20) {
                    LinearGradient(
                        colors: [Color.black.opacity(0.8), .clear],
                        startPoint: .top, endPoint: .bottom
                    )
                    .frame(height: 1)
                    
                    NavigationLink {
                        ReportsHistoryView()
                            .hideBackButton()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.black) // FIXME: - 컬러 수정
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .overlay {
                                Text("신고 내역 보기")
                                    .font(Font.system(size: 18, weight: .semibold)) // FIXME: - 폰트 수정
                                    .foregroundStyle(Color.white) // FIXME: - 컬러 수정
                            }
                    }
                }
            }
        }
        .paddingH16()
        .toolbar {
            ToolbarLeadingXmarkBackButton()
            ToolbarCenterTitle(text: "신고하기")
        }
    }
}

#Preview {
    NavigationStack {
        CompleteReportView(viewModel: ReportViewModel())
    }
}
