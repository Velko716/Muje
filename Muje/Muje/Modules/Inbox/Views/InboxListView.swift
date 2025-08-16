//
//  InboxView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI
import FirebaseAuth

struct InboxListView: View {
    @EnvironmentObject private var router: NavigationRouter
    @State private var viewModel: InboxListViewModel
    
    init() {
        let uid = FirebaseAuthManager.shared.currentUser?.userId ?? "anonymous"
        _viewModel = State(initialValue: InboxListViewModel(currentUserId: uid))
    }
    
    var body: some View {
        ZStack {
            VStack {
                Group {
                    if viewModel.isLoading { middleLoadingView }
                    else if viewModel.conversations.isEmpty { middleContentUnavailableView }
                    else { middleListView }
                }
                .animation(.easeInOut, value: viewModel.isLoading)
                .task { await viewModel.load() } // 화면 뜰 때 로드
                .refreshable { await viewModel.load() } // 당겨서 새로고침
                testBUttonView
            }
            .navigationTitle("나의 쪽지함")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
    
    // MARK: - Middle Loding View
    private var middleLoadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("쪽지를 불러오는 중…")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Middle ContentUnavailableView
    private var middleContentUnavailableView: some View {
        ContentUnavailableView(
            "대화를 시작해보세요",
            systemImage: "rectangle.and.pencil.and.ellipsis"
        )
    }
    
    // MARK: - Middle ListView
    private var middleListView: some View {
        List {
            ForEach(viewModel.conversations, id: \.conversationId) { convo in
                Button {
                    router.push(to: .inboxView(conversationId: convo.conversationId))
                } label: {
                    ConversationRow(
                        conversation: convo,
                        currentUserId: viewModel.currentUserId
                    )
                }
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: - 테스트 버튼 (삭제 예정)
    private var testBUttonView: some View {
        // 임시: 대화 생성 → 생성된 UUID로 이동
        Button {
            Task {
                do {
                    let meId = viewModel.currentUserId
                    let newChat = try await viewModel.createConversation(
                        postId: "post_123",
                        postTitle: "댄스월드 연합 동아리",
                        postOrganization: "댄스월드",
                        participant1: (id: meId, name: "나", role: .applicant),
                        participant2: (id: "recruiter_uid", name: "모집자", role: .recruiter)
                    )
                    router.push(to: .inboxView(conversationId: newChat.conversationId)) // 여기서 생성된 UUID 사용
                } catch {
                    print("create convo error:", error)
                }
            }
        } label: {
            Text("새 쪽지 시작하기")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
}

#Preview {
    NavigationStack {
        InboxListView()
            .environmentObject(NavigationRouter())
    }
}
