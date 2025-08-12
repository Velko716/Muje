//
//  ApplicationFormSection.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import SwiftUI

extension ApplicationFormView {
  var infoSection: some View {
    VStack {
      HStack {
        Image(systemName: "doc.text")
          .font(.headline)
          .fontWeight(.semibold)
        Text("아래 정보가 함께 제출돼요!")
          .font(.headline)
          .fontWeight(.semibold)
      }
      LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
      ], spacing: 12) {
        InfoTag(title: "이름", isActive: requirementFlags.requiresName)
        InfoTag(title: "학과 / 전공", isActive: requirementFlags.requiresDepartment)
        InfoTag(title: "나이", isActive: requirementFlags.requiresAge)
        InfoTag(title: "연락처", isActive: requirementFlags.requiresPhone)
        InfoTag(title: "학번", isActive: requirementFlags.requiresDepartment)
        InfoTag(title: "성별", isActive: requirementFlags.requiresGender)
        //        InfoTag(title: "이름", isActive: true)
        //        InfoTag(title: "학과 / 전공", isActive: true)
        //        InfoTag(title: "나이", isActive: true)
        //        InfoTag(title: "연락처", isActive: true)
        //        InfoTag(title: "학번", isActive: true)
        //        InfoTag(title: "성별", isActive: false)
      }
    }
    .padding(.vertical, 30)
  }
  
  var customQuestionSection: some View {
    VStack(alignment: .leading, spacing: 24) {
      ForEach(viewModel.customQuestion, id: \.questionText) { question in
        questionAnswerView(question)
      }
    }
  }
  
  var bottomButtonSection: some View {
    VStack {
      Button {
        router.push(
          to: .ApplicationPreview(
            postId: postId,
            requirementFlags: requirementFlags,
            postBasicInfo: postBasicInfo,
            customQuestion: viewModel.customQuestion,
            questionAnswer: questionAnswer,
          )
        )
      } label: {
        Text("지원서 작성 완료")
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 18)
          .background(Color.gray)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(.vertical, 32)
    .padding(.horizontal, 16)
  }
  
  func questionAnswerView(_ question: CustomQuestion) -> some View {
    let questionIdString = question.questionId.uuidString
    
    return VStack(alignment: .leading, spacing: 12) {
      Text(question.questionText)
        .fontWeight(.medium)
        .lineLimit(nil)
      TextField("내용을 입력해 주세요.", text: Binding(
          get: { questionAnswer[questionIdString] ?? "" },
          set: { questionAnswer[questionIdString] = $0 }
        ), axis: .vertical)
      .frame(maxWidth: .infinity)
      .frame(minHeight: 90, alignment: .topLeading)
      .padding(16)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.clear)
          .stroke(Color.gray, lineWidth: 1)
      )
    }
    .padding(.horizontal, 16)
  }
}
