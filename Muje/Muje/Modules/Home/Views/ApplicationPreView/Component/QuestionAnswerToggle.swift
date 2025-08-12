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
      HeaderSection
      
      Divider()
        .padding(.horizontal, 20)
      
      ScrollView {
       AnswerSection
      }
      .frame(height: isExpanded ? 200 : 60)
      .clipped()
    }
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .padding(.horizontal, 16)
  }
  
  private var HeaderSection: some View {
    Button {
      withAnimation(.easeInOut(duration: 0.3)) {
        isExpanded.toggle()
      }
    } label: {
      HStack {
        Text(question)
          .font(.body)
          .fontWeight(.medium)
          .foregroundStyle(Color.black)
          .multilineTextAlignment(.leading)
        
        Spacer()
        
        Image(systemName: "chevron.down")
          .font(.caption)
          .foregroundStyle(Color.gray)
          .rotationEffect(.degrees(isExpanded ? 180 : 0))
      }
      .padding(.top, 22)
      .padding(.bottom, 15)
      .padding(.horizontal, 20)
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  private var AnswerSection: some View {
    Text(answer)
      .font(.body)
      .foregroundStyle(.primary)
      .lineLimit(1)
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity, alignment: .topLeading)
      .fixedSize(horizontal: false, vertical: true)
      .padding(.horizontal, 20)
      .padding(.vertical, 20)
  }
}
