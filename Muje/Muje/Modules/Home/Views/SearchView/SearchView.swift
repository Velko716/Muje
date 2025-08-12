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
        SearchBar(typingStatus: $viewModel.isTyping, searchText: $viewModel.searchText)
        
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
        .environmentObject(NavigationRouter())
}
