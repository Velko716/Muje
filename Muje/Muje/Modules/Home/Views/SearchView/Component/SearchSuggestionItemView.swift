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
    let homeViewModel = HomeViewModel()
    
    var body: some View {
        List(filteredPosts, id: \.self) { post in
            VStack(alignment: .leading, spacing: 4) {
                Text(post.authorOrganization)
                    .font(.system(size: 14))
                
                Text(post.title)
                    .font(.system(size: 16))
            } //:VSTACK
            .onTapGesture {
                router.push(to: .RecruitmentDetailView(postId: homeViewModel.postIdToString(post.postId)))
                print("✅ 클릭한 공고 아이디 : \(post.postId)")
            }
        }
        .listStyle(PlainListStyle())
        .listRowSpacing(18)
    }
}

