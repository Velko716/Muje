//
//  RecruitmentCustomQuestionView.swift
//  Muje
//
//  Created by 김서현 on 8/24/25.
//

import SwiftUI

struct RecruitmentCustomQuestionView: View {
    
    @Bindable var viewModel: RecruitmentPostViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            TextWithDescription(MainText: "필수 정보")
            Spacer().frame(height: 8)
            
            ForEach(Array(viewModel.customQuestions.keys), id: \.self) { id in
                CustomQuestionItemView(
                    id: id,
                    text: Binding(
                        get: { viewModel.customQuestions[id] ?? "" },
                        set: { viewModel.customQuestions[id] = $0 }
                    ),
                    onDelete: { deleteId in
                        viewModel.customQuestions.removeValue(forKey: deleteId)
                    }
                    
                )
            }
            
            Button {
                viewModel.customQuestions[UUID()] = ""
            } label: {
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
        } //:VSTACK
    }
}
