//
//  SearchView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var router: NavigationRouter
    @State var viewModel: SearchViewModel
    
    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchText)
                .padding(.horizontal, 8)
                .onChange(of: viewModel.searchText) {
                    viewModel.filterPosts()
                }
            if viewModel.searchResults.isEmpty {
                Text("hehe")
            }
            
            Button {
                router.push(to: .searchResultView)
            } label: {
                Circle().fill(Color.blue)
            }

        } //: VSTACK
    }
        
}

#Preview {
    SearchView(viewModel: SearchViewModel())
        .environmentObject(NavigationRouter())
}
