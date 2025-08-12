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
    
    var body: some View {
        HStack {
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
            .frame(maxWidth: .infinity)
            .padding(.trailing, 13)
            Text("취소")
        }
        .frame(maxWidth: .infinity)
    }
}
