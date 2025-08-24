//
//  SearchSuggestionItem.swift
//  Muje
//
//  Created by 김서현 on 8/14/25.
//

import SwiftUI

struct SearchSuggestionItemView: View {
    @Binding var filteredPosts: [Post]
    @EnvironmentObject var router: NavigationRouter
    @State var viewModel: SearchViewModel
    
    var body: some View {
        List(filteredPosts, id: \.self) { post in
            VStack(alignment: .leading, spacing: 4) {
                Text(post.authorOrganization)
                    .font(.system(size: 14))
                
                Text(post.title)
                    .font(.system(size: 16))
            } //:VSTACK
            .contentShape(Rectangle())
            .onTapGesture {
                router.push(to: .RecruitmentDetailView(postId: viewModel.postIdToString(post.postId)))
            }
        }
        
        .listStyle(PlainListStyle())
        .listRowSpacing(18)
    }
}

