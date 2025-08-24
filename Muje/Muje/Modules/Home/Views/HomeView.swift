//
//  HomeView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: NavigationRouter
    @State var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("oo대학교 구인공고")
                    .font(.system(size: 22))
                Spacer()
                
                //MARK: 검색 아이콘
                Button(action: {
                    router.push(to: .searchView(posts: viewModel.postList))
                }) {
                    Image(systemName: "magnifyingglass")
                }
                
                //MARK: 알림 아이콘
                Button(action: {
                    router.push(to: .notificationView)
                }) {
                    Image(systemName: "bell")
                }
                
                //MARK: 설정 아이콘
                Button(action: {
                    router.push(to: .notificationView) // 나중에 설정뷰로 수정
                }) {
                    Image(systemName: "gearshape")
                }
            } //: HSTACK
            .padding(.horizontal, 16)
            
            ZStack(alignment: .bottom) {
                if viewModel.postList.count == 0 {
                    Text("공고가 아직 올라오지 않았어요.")
                        .frame(maxHeight: .infinity)
                }
                else {
                    List(viewModel.postList, id: \.postId) { post in
                        PostListItem(
                            post: post,
                            thumbnailImage: viewModel.thumbnailImages[post.postId]
                        )
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                router.push(to: .RecruitmentDetailView(postId: viewModel.postIdToString(post.postId)))
                                print("✅ 클릭한 포스트 아이디 : \(post.postId)")
                                
                            }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .listStyle(.plain)
                }
                
                PostCreateButton()
                    .padding(.bottom, 24)
            }
            
            
        } //: VSTACK
    }
}
