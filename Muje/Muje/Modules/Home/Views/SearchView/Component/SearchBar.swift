//
//  SearchBar.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var status: SearchStatus
    @EnvironmentObject var router: NavigationRouter
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            // MARK: 왼쪽 셰브론
            Button(action: {
                searchText = ""
                router.pop()
            }) {
                Image(.chevronLeft)
            }
            
            //MARK: 검색바
            HStack {
                Image(.searchBarIcon)
                ZStack(alignment: .leading) {
                    if searchText.isEmpty {
                        Text("제목, 단체명")
                            .body2_16Regular()
                            .foregroundStyle(.gray500)
                    }
                    TextField("", text: $searchText)
                        .font(.pretendard(type: .regular, size: 16))
                        .foregroundStyle(.gray700)
                }
                .submitLabel(.search)
                .frame(height: 30)
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { oldValue, newValue in
                    if newValue {
                        status = .typing
                    }
                }
                Spacer()
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 11.5)
            .background(
                RoundedRectangle(cornerRadius: 100)
                    .fill(.gray50)
            )
        }
        .frame(maxWidth: .infinity)
        .onTapGesture {
            isTextFieldFocused = true
        }
    }
}
