//
//  ApplicationFormSection.swift
//  Muje
//
//  Created by 조재훈 on 8/9/25.
//

import SwiftUI

extension ApplicationFormView {
    var infoSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(.checkbox)
                Text("아래 정보가 함께 제출돼요")
                    .body2SemiBold16()
                    .foregroundStyle(.pointSkyBlue)
                Spacer()
            }
            HStack(spacing: 6) {
                InfoTag(title: "이름", isActive: requirementFlags.requiresName)
                InfoTag(title: "나이", isActive: requirementFlags.requiresAge)
                InfoTag(title: "성별", isActive: requirementFlags.requiresGender)
                Spacer()
            }
            Spacer().frame(height: 8)
            HStack(spacing: 6) {
                InfoTag(title: "학과 / 전공", isActive: requirementFlags.requiresDepartment)
                InfoTag(title: "학번", isActive: requirementFlags.requiresDepartment)
                InfoTag(title: "연락처", isActive: requirementFlags.requiresPhone)
                Spacer()
            }
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
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
          if allAnswersFilled {
              router.push(
                to: .applicationPreview(
                  postId: postId,
                  requirementFlags: requirementFlags,
                  postBasicInfo: postBasicInfo,
                  customQuestion: viewModel.customQuestion,
                  questionAnswer: questionAnswer,
                )
              )
          }
      } label: {
        Text("신청서 작성 완료")
              .foregroundStyle(allAnswersFilled ? .graywhite : .gray400)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 18)
          .background(allAnswersFilled ? .grayblack : .gray300)
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding(EdgeInsets(.init(top: 20, leading: 16, bottom: 43, trailing: 16)))
  }
  
    //Binding get set 수정
  func questionAnswerView(_ question: CustomQuestion) -> some View {
    let questionIdString = question.questionId.uuidString
      let config = Font.lineHeight(
          type: .medium,
          fontSize: 16,
          lineHeightPercent: 1.85,
          letterSpacingPercent: -1
      )
    return VStack(alignment: .leading, spacing: 12) {
      Text(question.questionText)
        .body1SemiBold18()
        .foregroundStyle(.gray700)
        .lineLimit(nil)
        TextField(
            "",
            text: Binding(
                get: { questionAnswer[questionIdString] ?? ""
                },
                set: { newValue in
                    questionAnswer[questionIdString] = newValue
                    isAnswerFilled[questionIdString] = !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                }
            ),
            prompt: Text("내용을 입력해주세요")
            ,
            axis: .vertical
        )
      .padding(16)
      .focused($focusedQuestionId, equals: questionIdString)
      .frame(maxWidth: .infinity)
      .frame(minHeight: 108, alignment: .topLeading)
    
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.clear)
          .stroke(focusedQuestionId == questionIdString ? .pointSkyBlue : Color.gray, lineWidth: 1)
      )
      .font(.pretendard(type: .medium, size: 16))
      .padding(.vertical, config.verticalPadding)
      .tracking(config.letterSpacing)
      .foregroundStyle(.gray700, .gray500) //첫번째는 텍스트, 두번째는 플레이스 홀더 컬러
    }
    .padding(.horizontal, 16)
  }
    private var allAnswersFilled: Bool {
        guard !isAnswerFilled.isEmpty,
              isAnswerFilled.count == viewModel.customQuestion.count else {
            return false
        }
        return isAnswerFilled.values.allSatisfy { $0 }
    }
}
