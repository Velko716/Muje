//
//  SearchBar.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

// FIXME: 폰트, 컬러 수정

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var status: SearchStatus
    @EnvironmentObject var router: NavigationRouter
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            
            //MARK: 왼쪽 셰브론
            Button(action: {
                searchText = ""
                router.pop()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24))
            }
            
            //MARK: 검색바
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(
                    "",
                    text: $searchText,
                    prompt: Text("제목, 작성자") //폰트, 컬러 설정할 수 있음
                )
                .submitLabel(.search)
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    if newValue {
                        status = .typing
                    }
                }
                // 검색창 들어가자마자 자동으로 키보드 활성화
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.isTextFieldFocused = true
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 11.5)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.gray)
                    .opacity(0.2)
            )
        }
        .frame(maxWidth: .infinity)
    }
}
