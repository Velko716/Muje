//
//  HomeView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: NavigationRouter
    @State var viewModel: HomeViewModel
     
    var body: some View {
        VStack {
            List(viewModel.postList, id: \.self) { post in
                PostListItem(post: post)
            }
            .task { viewModel.postListFetch() }
            .listStyle(.grouped)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            Text("hello?")
        }
    }
}

#Preview {
    HomeView(viewModel: .mock)
        .environmentObject(NavigationRouter())
}
