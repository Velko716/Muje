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
    VStack(spacing: 0) {
      questionHeader
      AnswerSection
    }
    .background(Color.white)
//    .overlay(
//      RoundedRectangle(cornerRadius: 12)
//        .stroke(Color(.systemGray), lineWidth: 1)
//    )
//    .clipShape(RoundedRectangle(cornerRadius: 12))
//    .animation(.easeInOut(duration: 0.3), value: isExpanded)
  }
  
  private var questionHeader: some View {
    Button {
      
        isExpanded.toggle()
      
    } label: {
      HStack {
        Text(question)
          .font(.body)
          .fontWeight(.medium)
          .foregroundStyle(Color.black)
          .multilineTextAlignment(.leading)
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
        
        Image(systemName: "chevron.down")
          .font(.caption)
          .foregroundStyle(Color.gray)
          .rotationEffect(.degrees(isExpanded ? 180 : 0))
          .animation(.easeInOut(duration: 0.3), value: isExpanded)
      }
      .padding(.horizontal, 20)
      .padding(.top, 20)
      .padding(.bottom, isExpanded ? 16 : 12)
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  private var AnswerSection: some View {
    Text(answer)
      .font(.body)
      .foregroundStyle(.primary)
      .lineLimit(isExpanded ? nil : 1)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 20)
      .padding(.top, isExpanded ? 16 : 8)
      .padding(.bottom, 20)
      .background(Color.white)
//      .animation(.easeInOut(duration: 0.3), value: isExpanded)
  }
}

#Preview {
  QuestionAnswerToggle(
    question: "햄버거 햄버거 햄버거",
    answer: "우와와와와와오아ㅘ오아 개많이 먹음 진짜 개맣ㄴ이ㅏ먼ㅇ리"
  )
}
