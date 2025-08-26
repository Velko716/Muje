//
//  BlockHistoryView.swift
//  Muje
//
//  Created by 김진혁 on 8/26/25.
//

import SwiftUI

struct BlockHistoryView: View {
    @State private var viewModel: BlockHistoryViewModel = .init()
    
    
    var body: some View {
        ZStack {
            VStack {
                createBlockTestButtonView
            }
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: "차단 내역")
        }
    }
    
    // MARK: - 바텀) 차단 생성 테스트 버튼 (삭제 예정)
    private var createBlockTestButtonView: some View {
        Button {
            Task {
                await viewModel.createBlockTestButtonTapped()
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
    BlockHistoryView()
}
