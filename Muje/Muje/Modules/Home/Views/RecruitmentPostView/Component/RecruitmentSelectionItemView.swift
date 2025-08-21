//
//  RecruitmentSelectionItemView.swift
//  Muje
//
//  Created by 김서현 on 8/20/25.
//

import SwiftUI

struct RecruitmentSelectionItemView: View {
    let IsBasicInfo: Bool
    @State var text: String
    @State var IsChecked: Bool = false
    @FocusState var IsTyping: Bool
    
    var body: some View {
        if IsBasicInfo {
            Button {
                IsChecked.toggle()
            } label: {
                
                HStack {
                    Text(text)
                        .font(.system(size: 16))
                        .foregroundStyle(IsChecked ? Color.blue : Color.gray)
                    Spacer()
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.2))
                        .frame(width: 26, height: 26)
                        .overlay(IsChecked ? Image(.checkCircle) : nil)
                    
                } //: HSTACK
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(IsChecked ? Color.blue : Color.gray, lineWidth: 1)
                        .fill(IsChecked ? Color.blue.opacity(0.2) : Color.clear)
                )
            }
        } //: IF
        else {
            HStack {
                // FIXME: 플레이스 홀더는 랜덤 질문으로 변경
                TextField("자기 소개 300자를 입력해주세요", text: $text)
                    .focused($IsTyping)
                    .font(.system(size: 16))
                Spacer()
                Button {
                    //FIXME: 텍스트 필드 사라지는 액션 추가
                } label: {
                    Image(.removeCIrcle)
                        .resizable()
                        .frame(width: 26, height: 26)
                }

            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 21.5)
            .background (
                RoundedRectangle(cornerRadius: 10)
                    .stroke(IsTyping ? Color.blue : Color.gray, lineWidth: 1)
            )
        }
        
        
        
    }
    
}
