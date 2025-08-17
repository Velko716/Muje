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
       VStack {
           HStack {
               Text("oo대학교 구인공고")
               Spacer()
               
               //MARK: 검색 아이콘
               Button(action: {
                   router.push(to: .searchView)
               }) {
                   Image(systemName: "magnifyingglass")
               }
               
               //MARK: 알림 아이콘
               Button(action: {
                   router.push(to: .notificationView)
               }) {
                   Image(systemName: "bell")
               }
           } //: HSTACK
           .padding(.horizontal, 16)
           
               List(viewModel.postList, id: \.postId) { post in
                   PostListItem(post: post)
               }
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .listStyle(.plain)
               .listRowBackground(Color.clear)
               .listRowSeparator(.hidden)
               .listRowInsets(EdgeInsets())
           
       } //: VSTACK
       
   }
}
