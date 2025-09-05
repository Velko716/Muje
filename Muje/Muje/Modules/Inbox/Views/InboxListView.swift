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
            VStack(alignment: .leading) {
                Text("나의 쪽지함")
                    .font(Font.pretendard(type: .semiBold, size: 20))
                    .foregroundStyle(Color.gray700)
                    .padding([.horizontal, .bottom], 16)
                Group {
                    if viewModel.isLoading { middleLoadingView }
                    else if FirebaseAuthManager.shared.currentUser == nil {
                        middleUnloginView
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    else if viewModel.conversations.isEmpty {
                        middleContentUnavailableView
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    else { middleListView }
                }
                .animation(.easeInOut, value: viewModel.isLoading)
                .onAppear { viewModel.start() } // FIXME: - 코드 수정
                .onDisappear { viewModel.stop() }
                //testBUttonView
            }
        }
    }
    
    // MARK: - Middle Loding View
    private var middleLoadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("쪽지를 불러오는 중…")
                .font(.caption) // FIXME: - 피그마 미반영
                .foregroundStyle(.secondary) // FIXME: - 피그마 미반영
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Middle ContentUnavailableView
    private var middleContentUnavailableView: some View {
        VStack {
            Rectangle()
                .fill(Color.gray100)
                .overlay {
                    // TODO: 그래픽으로 대체하기
                    Text("그래픽")
                        .font(Font.pretendard(type: .semiBold, size: 18))
                        .foregroundStyle(Color.gray500)
                }
                .frame(width: 234, height: 207)
            Spacer().frame(height: 20)
            Text("대화를 시작해보세요")
                .font(Font.pretendard(type: .semiBold, size: 16))
                .foregroundStyle(Color.gray500)
            Spacer()
        }
    }
    
    // MARK: - Middle 비로그인 뷰
    private var middleUnloginView: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.gray100)
                .overlay {
                    // TODO: 그래픽으로 대체하기
                    Text("그래픽")
                        .font(Font.pretendard(type: .semiBold, size: 18))
                        .foregroundStyle(Color.gray500)
                }
                .frame(width: 234, height: 207)
            Spacer().frame(height: 20)
            Text("대화를 시작해보세요")
                .font(Font.pretendard(type: .semiBold, size: 16))
                .foregroundStyle(Color.gray500)
            Spacer()
        }
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
                        currentUserId: viewModel.currentUserId,
                        unreadCount: convo.unread?[viewModel.currentUserId] ?? 0
                    )
                }
            }
        }
        .listStyle(.plain)
    }
    
//    // MARK: - 테스트 버튼 (삭제 예정)
//    private var testBUttonView: some View {
//        // 임시: 대화 생성 → 생성된 UUID로 이동
//        Button {
//            Task {
//                do {
//                    let meId = viewModel.currentUserId
//                    let newChat = try await viewModel.createConversation(
//                        postId: "post_123",
//                        postTitle: "댄스월드 연합 동아리",
//                        postOrganization: "댄스월드",
//                        participant1: (id: meId, name: "나", role: .applicant),
//                        participant2: (id: "FTMIffTVLdb8GuhHweHJEgAwFqB2", name: "모집자", role: .recruiter)
//                    )
//                    router.push(to: .inboxView(conversationId: newChat.conversationId)) // 여기서 생성된 UUID 사용
//                } catch {
//                    print("create convo error:", error)
//                }
//            }
//        } label: {
//            Text("새 쪽지 시작하기")
//                .frame(maxWidth: .infinity)
//        }
//        .buttonStyle(.borderedProminent)
//        .padding()
//    }
}

#Preview {
    InboxListView()
        .environmentObject(NavigationRouter())
}
