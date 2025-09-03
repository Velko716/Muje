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
                blockListItemView(viewModel.blocks)
                Spacer()
                createBlockTestButtonView
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: "차단 내역")
        }
        .task {
            await viewModel.loadBlockData()
            print("reports :\(viewModel.blocks)")
        }
    }
    
    // MARK: - 리스트 뷰 분기처리
    @ViewBuilder
    func blockListItemView(_ blocks: [Block]) -> some View {
        switch blocks.isEmpty {
        case true:
            emptyBlockListView
        case false:
            blockListView
        }
    }
    
    // MARK: - 차단 리스트 뷰 (데이터가 존재 하지 않을때)
    private var emptyBlockListView: some View {
        VStack {
            Spacer().frame(height: 48) // FIXME: - 수정
            Text("차단 내역이 없어요")
                .font(Font.system(size: 16, weight: .semibold)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
    }
    
    // MARK: - 차단 리스트 뷰 (데이터 1개 이상일 때)
    private var blockListView: some View {
        List() {
            ForEach(viewModel.blocks, id: \.blockedUserId) { row in
                BlockHistoryListItem(blockedName: viewModel.blockedUserNames[row.blockedUserId] ?? "알 수 없음") {
                    Task {
                        await viewModel.unblockUser(to: row.blockedUserId)
                    }
                    print("row.blockedUserId : \(row.blockedUserId)")
                }
                .listRowInsets(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
        }
        .listStyle(.plain)
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
