//
//  SearchResultItemView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var router: NavigationRouter
    let homeViewModel = HomeViewModel() // 가장 빠르게 구현할 수 있는 방법이 뷰모델을 여기에 불러오는 방식이라고 생각해서 썼습니다. 추후 수정 해야함!
    @Binding var searchText: String
    @Binding var filteredPosts: [Post]
    
    var body: some View {
        VStack {
            List(filteredPosts, id: \.self) { post in
                /*지금은 homeViewModel의 메서드 getThumbnailUrl()를 사용하려고 뷰모델을 가져왔는데, 좋은 방식은 아닌 것 같아서 추후에 수정해야 할 것 같아요.
                 thumbnailUrl을 homeView에서 주입 받거나 (처리 시간이 훨씬 줄어들 것 같아요.)
                 혹은 post랑 썸네일을 한 번에 묶은 모델(postWithThumbnailImage - 미리보기 할 때 쓰기 좋을 것 같아요.)을 생성할 수도 있을 것 같습니다.*/
                PostListItem(post: post, thumbnailImage: homeViewModel.thumbnailImages[post.postId])
                    .onTapGesture {
                        router.push(to: .RecruitmentDetailView(postId: homeViewModel.postIdToString(post.postId)))
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .listStyle(.plain)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .ignoresSafeArea()
            
        } //: VSTACK
        
    } //: main
}
