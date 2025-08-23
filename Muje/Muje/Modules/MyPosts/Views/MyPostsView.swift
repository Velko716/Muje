//
//  MyPostsView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct MyPostsView: View {
    @State var myPostsViewModel: MyPostsViewModel = .init()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 56) {
                topView
                postView
                applyView
            }
        }
        .safeAreaPadding(.horizontal, 16)
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 21) {
            VStack(alignment: .leading, spacing: 0) {
                Text("다가오는 일정")
                    .font(.title2)
                    .foregroundStyle(Color.black)
                Text("내일까지 다가오는 일정을 보여드려요")
                    .foregroundStyle(Color.gray)
            }
            VStack(spacing: 8) {
                Button(action: {
                    myPostsViewModel.isRecruit.toggle()
                }, label: {
                    UpcomingRecruitCard(myPostsViewModel: $myPostsViewModel, title: "모집 면접", codition: myPostsViewModel.isRecruit)
                })
                Button(action: {
                    myPostsViewModel.isApply.toggle()
                }, label: {
                    UpcomingApplyCard(myPostsViewModel: $myPostsViewModel, title: "지원 면접", codition: myPostsViewModel.isApply)
                })
                
            }
        }
    }
    
    private var postView: some View {
        VStack(alignment: .leading, spacing: 21) {
            Text("내가 올린 공고 \(myPostsViewModel.recruitPosts.count)")
                .font(.title2)
                .foregroundStyle(Color.black)
            
            if myPostsViewModel.recruitPosts.isEmpty {
                emptyPost(title: "올린 공고가 없습니다")
            } else {
                TabView(selection: $myPostsViewModel.currentRecruitPage) {
                    ForEach(myPostsViewModel.recruitPosts.indices, id: \.self) { index in
                        RecruitPostCard(item: myPostsViewModel.recruitPosts[index], isPost: true)
                            .tag(index)
                    }
                }
                .frame(height: 260)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            if myPostsViewModel.recruitPosts.count > 1 {
                PageController(pageCount: myPostsViewModel.recruitPosts.count, currentPage: $myPostsViewModel.currentRecruitPage)
            }
        }
    }
    
    private var applyView: some View {
        VStack(alignment: .leading, spacing: 21) {
            Text("내가 지원한 공고 \(myPostsViewModel.applyPosts.count)")
                .font(.title2)
                .foregroundStyle(Color.black)
            
            if myPostsViewModel.applyPosts.isEmpty {
                emptyPost(title: "지원한 공고가 없습니다")
            } else {
                TabView(selection: $myPostsViewModel.currentApplyPage) {
                    ForEach(myPostsViewModel.applyPosts.indices, id: \.self) { index in
                        RecruitPostCard(item: myPostsViewModel.applyPosts[index], isPost: false)
                            .tag(index)
                    }
                }
                .frame(height: 260)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            if myPostsViewModel.applyPosts.count > 1 {
                PageController(pageCount: myPostsViewModel.applyPosts.count, currentPage: $myPostsViewModel.currentApplyPage)
            }
        }
    }
    
    func emptyPost(title: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 360, height: 260)
            .overlay(content: {
                Text(title)
            })
    }
}

#Preview {
    MyPageView()
}
