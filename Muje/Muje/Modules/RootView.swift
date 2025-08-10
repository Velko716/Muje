//
//  RootView.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var router: NavigationRouter
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
                }
            })
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationRoutingView(destination: destination)
                    .environmentObject(router)
            }
        }
    }
    
    
    private func tabLabel(_ tab: TabCase) -> some View {
        VStack(spacing: 12) {
            Image(systemName: tab.icon)
                
            Text(tab.rawValue)
                .font(.caption)
                .foregroundStyle(Color.black)
        }
    }
    
    @ViewBuilder
    private func tabView(tab: TabCase) -> some View {
        Group {
            switch tab {
            case .home:
                HomeView(viewModel: .mock)
            case .myPosts:
                MyPostsView()
            case .inbox:
                InboxView()
            case .myPage:
                MyPageView()
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationRouter())
}
