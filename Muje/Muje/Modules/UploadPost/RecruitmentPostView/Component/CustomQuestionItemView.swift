//
//  CustomQuestionItemView.swift
//  Muje
//
//  Created by 김서현 on 8/24/25.
//

import SwiftUI

struct CustomQuestionItemView: View {
  let question: DraftCustomQuestion
  let onTextChange: (String) -> Void
  let onDelete: () -> Void
    let config = Font.lineHeight(type: .medium, fontSize: 16, lineHeightPercent: 1.85, letterSpacingPercent: -1)
    @State private var text: String = ""
    @FocusState var isTyping: Bool
    var body: some View {
        HStack {
            // FIXME: 플레이스 홀더는 랜덤 질문으로 변경
            // 랜덤 질문 따로 정리 되어 있는게 없어서 지금은 자기 소개 300자로만 넣었습니다!
            TextField("자기 소개 300자를 입력해주세요", text: $text)
                .focused($isTyping)
                .font(.pretendard(type: .medium, size: 16))
                .padding(.vertical, config.verticalPadding)
                .tracking(config.letterSpacing)
                .onChange(of: text) { _, newValue in
                    onTextChange(newValue)
                }
            Spacer()
            Button {
                onDelete()
            } label: {
                Image(.removeCircleFill)
            }

        } //: HSTACK
        .frame(maxWidth: .infinity)
        .padding(18)
        .background (
            RoundedRectangle(cornerRadius: 10)
                .stroke(isTyping ? .pointSkyBlue : .gray200, lineWidth: 1)
        )
    }
}
