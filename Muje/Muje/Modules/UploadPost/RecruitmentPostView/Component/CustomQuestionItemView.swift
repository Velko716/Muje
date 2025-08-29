//
//  CustomQuestionItemView.swift
//  Muje
//
//  Created by 김서현 on 8/24/25.
//

import SwiftUI

struct CustomQuestionItemView: View {
    // 커스텀 질문은 각자 하나의 객체로 쓰여야 하기 때문에 id를 넣었습니다 (생성, 삭제를 위함)
    let id: UUID
    
    @Binding var text: String
    @FocusState var IsTyping: Bool
    
    var onDelete: ((UUID) -> Void)? = nil //부모뷰에서 받을거에욤
    
    var body: some View {
        HStack {
            // FIXME: 플레이스 홀더는 랜덤 질문으로 변경
            // 랜덤 질문 따로 정리 되어 있는게 없어서 지금은 자기 소개 300자로만 넣었습니다!
            TextField("자기 소개 300자를 입력해주세요", text: $text)
                .focused($IsTyping)
                .font(.system(size: 16))
            Spacer()
            Button {
                onDelete!(id)
            } label: {
                Image(.removeCIrcle)
                    .resizable()
                    .frame(width: 26, height: 26)
            }

        } //: HSTACK
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 21.5)
        .background (
            RoundedRectangle(cornerRadius: 10)
                .stroke(IsTyping ? Color.blue : Color.gray, lineWidth: 1)
        )
        
    }
}
