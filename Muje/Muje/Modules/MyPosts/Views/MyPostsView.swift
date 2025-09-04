//
//  MyPostsView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct MyPostsView: View {
    @State var myPostsViewModel: MyPostsViewModel = .init()
    @State var selectViewModel: SelectViewModel = .init()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 56) {
              topView
              postView
              applyView
          }
        }
        .task {
          await myPostsViewModel.loadAllData()
        }
//        .onAppear {
//          Task {
//            await myPostsViewModel.loadAllDataIfNeed()
//          }
//        }
//        .refreshable {
//          Task {
//            await myPostsViewModel.forceRefresh()
//          }
//        }
        .safeAreaPadding(.horizontal, 16)
        .fullScreenCover(isPresented: $selectViewModel.isSetting) {
            SelectView(selectViewModel: selectViewModel)
        }
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
                    UpcomingCard(myPostsViewModel: $myPostsViewModel, title: "모집 면접", codition: myPostsViewModel.isRecruit, lists: myPostsViewModel.upcomingRecruitLists(), isRecruitment: true)
                })
                Button(action: {
                    myPostsViewModel.isApply.toggle()
                }, label: {
                    UpcomingCard(myPostsViewModel: $myPostsViewModel, title: "지원 면접", codition: myPostsViewModel.isApply, lists: myPostsViewModel.upcomingApplyLists(), isRecruitment: false)
                })
                
            }
        }
    }
    
    private var postView: some View {
        VStack(alignment: .leading, spacing: 21) {
            Text("내가 올린 공고 \(myPostsViewModel.uploadPost.count)")
                .font(.title2)
                .foregroundStyle(Color.black)
            
            if myPostsViewModel.uploadPost.isEmpty {
                emptyPost(title: "올린 공고가 없습니다")
            } else {
                TabView(selection: $myPostsViewModel.currentRecruitPage) {
                    ForEach(myPostsViewModel.uploadPost.indices, id: \.self) { index in
                        RecruitPostCard(item: myPostsViewModel.uploadPost[index], isPost: true)
                            .tag(index)
                    }
                }
                .frame(height: 260)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            if myPostsViewModel.uploadPost.count > 1 {
                PageController(pageCount: myPostsViewModel.uploadPost.count, currentPage: $myPostsViewModel.currentRecruitPage)
                
            }
        }
    }
    
    private var applyView: some View {
        VStack(alignment: .leading, spacing: 21) {
            Text("내가 지원한 공고 \(myPostsViewModel.applicationPost.count)")
                .font(.title2)
                .foregroundStyle(Color.black)
            
            if myPostsViewModel.applicationPost.isEmpty {
                emptyPost(title: "지원한 공고가 없습니다")
            } else {
                TabView(selection: $myPostsViewModel.currentApplyPage) {
                    ForEach(myPostsViewModel.applicationPost.indices, id: \.self) { index in
                        ApplyPostCard(selectViewModel: selectViewModel, item: myPostsViewModel.applicationPost[index], isPost: false)
                            .tag(index)
                    }
                }
                .frame(height: 260)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            if myPostsViewModel.applicationPost.count > 1 {
                PageController(pageCount: myPostsViewModel.applicationPost.count, currentPage: $myPostsViewModel.currentApplyPage)
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
    MyPostsView()
}
