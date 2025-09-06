//
//  QuestionAnswerToggle.swift
//  Muje
//
//  Created by 조재훈 on 8/10/25.
//

import SwiftUI

struct QuestionAnswerToggle: View {
    let question: String
    let answer: String
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            questionHeader
            AnswerSection
        }
        .background(Color.white)
    }
    
    private var questionHeader: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                Text(question)
                    .body1SemiBold18()
                    .foregroundStyle(.gray800)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Image(.chevronDown)
                    .foregroundStyle(.gray700)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut(duration: 0.3), value: isExpanded)
            }
            .padding(.horizontal, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var AnswerSection: some View {
        Text(answer)
            .body2SemiBold16()
            .foregroundStyle(.gray700)
            .lineLimit(isExpanded ? nil : 2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }
}

#Preview {
    QuestionAnswerToggle(
        question: "햄버거 햄버거 햄버거",
        answer: "우와와와와와오아ㅘ오아 개많이 먹음 진짜 개맣ㄴ이ㅏ먼ㅇ리"
    )
}
