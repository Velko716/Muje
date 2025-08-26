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
                
                createReportTestButtonView
            }
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
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
        }
    }
    
    
}

#Preview {
    NavigationStack {
        ReportsHistoryView()
    }
}
