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
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("상세 내용을 작성해주세요")
                    .font(Font.system(size: 22, weight: .semibold)) // FIXME: - 폰트 수정
                    .foregroundStyle(Color.black) // FIXME: - 컬러 수정
                
                Spacer().frame(height: 27)
                
                PlaceholderTextEditor(
                    text: $viewModel.detailText,
                    placeholder: "신고 내용을 상세하게 적어주세요"
                )
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
                        CompleteReportView(viewModel: viewModel)
                            .hideBackButton()
                        
                        task {
                            // TODO: 현재 유저의 신고 기능 추가하기
                            await viewModel.createReport(
                                reportedUserId: viewModel.reportedUserId ?? "",
                                conversationId: viewModel.conversationId ?? ""
                            )
                        }
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.detailText.isEmpty ? Color.gray : Color.red) // FIXME: - 컬러 수정
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .overlay {
                                Text("신고하기")
                                    .font(Font.system(size: 18, weight: .semibold)) // FIXME: - 폰트 수정
                                    .foregroundStyle(viewModel.detailText.isEmpty ? Color.black : Color.white) // FIXME: - 컬러 수정
                            }
                    }
                    .disabled(viewModel.detailText.isEmpty)
                }
            }
            
        }
        .paddingH16()
        .dismissKeyboardOnTap()
        .toolbar {
            ToolbarLeadingXmarkBackButton()
            ToolbarCenterTitle(text: "신고하기")
        }
    }
}

#Preview {
    NavigationStack {
        ReportDetailView(viewModel: ReportViewModel())
    }
}

// FIXME: - UI 업데이트 필요함 + 소스 코드 위치 이동
/// 둥근 박스 스타일의 TextEditor + placeholder
struct PlaceholderTextEditor: View {
    @Binding var text: String
    var placeholder: String
    @FocusState private var focused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .focused($focused)
                .font(.system(size: 17))
                .padding(12)
                .frame(maxHeight: 212, alignment: .topLeading)
                .scrollContentBackground(.hidden)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(uiColor: .secondarySystemBackground))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(uiColor: .systemGray4), lineWidth: 1)
                )
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 17))
                    .foregroundStyle(Color(uiColor: .systemGray3))
                    .padding([.top, .leading], 16)
                    .allowsHitTesting(false)
            }
        }
    }
}
