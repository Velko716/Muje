//
//  RootView.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject private var unreadBadge: UnreadBadgeStore
    @EnvironmentObject private var deepLink: DeepLinkController
    @State private var tabcase: TabCase = .home
    
    
    var body: some View {
        NavigationStack(path: $router.destination) {
            TabView(selection: $tabcase, content: {
                ForEach(TabCase.allCases, id: \.rawValue) { tab in
                    Tab(
                        value: tab,
                        content: {
                            tabView(tab: tab)
                                .tag(tab)
                        },
                        label: {
                            tabLabel(tab)
                        })
                    .badge((tab == .inbox ? (unreadBadge.total > 0 ? unreadBadge.total : nil)
                            : nil) ?? 0)
                }
            })
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(router)
            }
            .onAppear {
                pushIfNeeded()
            }
            .onChange(of: deepLink.pendingConversationId) { _, _ in
                pushIfNeeded()
            }
        }
    }
    
    @MainActor
    private func pushIfNeeded() {
        guard let cid = deepLink.pendingConversationId else { return }
        router.push(to: .inboxView(conversationId: cid))
        deepLink.pendingConversationId = nil // 재진입 방지
    }
    
    private func tabLabel(_ tab: TabCase) -> some View {
        let isSelected = tabcase == tab
        return VStack(spacing: 12) {
            Image(tab.icon)
                .renderingMode(.template)
                .foregroundStyle(isSelected ? Color.black : Color.gray.opacity(0.55)) // FIXME: - 컬러 수정
            Text(tab.rawValue)
                .font(.caption)
                .foregroundStyle(Color.black) // FIXME: - 컬러 수정
        }
        .animation(.snappy, value: tabcase) // 애니메이션 추가
    }
    
    @ViewBuilder
    private func tabView(tab: TabCase) -> some View {
        Group {
            switch tab {
            case .home:
                HomeView()
            case .myPosts:
                MyPostsView()
            case .inbox:
                InboxListView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationRouter())
        .environmentObject(UnreadBadgeStore())
        .environmentObject(DeepLinkController())
}
