//
//  SearchBar.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

// FIXME: 폰트, 컬러 수정

import SwiftUI

struct SearchBar: View {
    @Binding var typingStatus: Bool
    @Binding var searchText: String
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        HStack {
            
            //MARK: 왼쪽 셰브론
            Button(action: {
                router.pop()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24))
            }
            
            //MARK: 검색바
            HStack {
                Image(systemName: "magnifyingglass")
                Text(
                    typingStatus
                     ? searchText
                     : "제목, 검색어"
                )
                Spacer()
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 11.5)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.white)
            )
        }
        .frame(maxWidth: .infinity)
    }
}
