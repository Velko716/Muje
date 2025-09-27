//
//  RecruitmentPostView.swift
//  Muje
//
//  Created by 김서현 on 8/21/25.
//

import SwiftUI

struct RecruitmentPostView: View {
  @EnvironmentObject var router: NavigationRouter
  @State var typingText = ""
  @Bindable var viewModel: RecruitmentPostViewModel
  
  var body: some View {
      VStack(alignment: .leading) {
        titleView
        basicInfoView
        customQuestionView
      }
      .padding(.bottom, 160)
  }
  
  private var titleView: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(.iconInformation)
              .frame(width: 20, height: 20)
        Text("모집글 작성이 완료되면 수정할 수 없어요")
          .caption14Medium()
          .foregroundStyle(.gray500)
      }
    }
    .padding(.bottom, 40)
  }
  
  private var basicInfoView: some View {
    VStack(alignment: .leading, spacing: 12) {
      TextWithDescription(MainText: "기본 정보")
      ForEach(RecruitmentField.allCases) { field in
        BasicInfoSelectionItemView(
          field: field,
          text: field.rawValue,
          isChecked: viewModel.basicInfoChecked[field] ?? false,
          toggle: { viewModel.basicInfoChecked[field]?.toggle() }
        )
      }
    }
    .padding(.bottom, 32)
  }
  
  private var customQuestionView: some View {
    VStack(alignment: .leading) {
      TextWithDescription(MainText: "필수 정보")
        .padding(.bottom, 12)
      ForEach(viewModel.customQuestions) { question in
        CustomQuestionItemView(
          question: question,
          onTextChange: { newText in
            viewModel.updateCustomQuestion(id: question.id, text: newText)
          },
          onDelete: { viewModel.removeCustomQuestion(id: question.id) }
        )
      }
      addQuestionButton
    }
  }
  
  private var addQuestionButton: some View {
    Button(action: viewModel.addCustomQuestion) {
      VStack(alignment: .center, spacing: -2) {
        Text("커스텀 질문 추가하기")
              .body1Medium16()
              .foregroundStyle(.pointSkyBlue)
        Image(.addCircleFill)
              .foregroundStyle(.pointSkyBlue)
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.vertical, 17)
      .padding(.bottom, -3)
      .background(
        RoundedRectangle(cornerRadius: 10)
            .fill(.gray100)
      )
    }
  }
}

#Preview {
  RecruitmentPostView(viewModel: RecruitmentPostViewModel())
}
