//
//  SearchResultItemView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var router: NavigationRouter
    @Binding var searchText: String
    @Binding var filteredPosts: [Post]
    
    var body: some View {
        VStack {
            List(filteredPosts, id: \.self) { post in
                PostListItem(post: post)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .ignoresSafeArea()
            
        } //: VSTACK
        
    } //: main
}
