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
      } //: VSTACK
      .padding(.bottom, 160)
  }
  
  private var titleView: some View {
    VStack(alignment: .leading) {
//      Text("지원자로부터\n수집할 정보를 선택해주세요")
//        .font(.system(size: 24))
      HStack {
        Image(systemName: "exclamationmark.circle")
          .font(.system(size: 16))
        Text("모집글 작성이 완료되면 수정할 수 없어요")
          .font(.system(size: 14))
          .foregroundStyle(.gray)
      }
//      .padding(.top, 8)
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
      VStack(alignment: .center) {
        Text("커스텀 질문 추가하기")
        Image(.addCircle)
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.gray.opacity(0.2))
      )
    }
  }
}

#Preview {
  RecruitmentPostView(viewModel: RecruitmentPostViewModel())
}
