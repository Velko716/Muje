//
//  RecruitmentBasicInfoView.swift
//  Muje
//
//  Created by 김서현 on 8/21/25.
//

import SwiftUI

struct RecruitmentBasicInfoView: View {
    @Bindable var viewModel: RecruitmentPostViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            //TODO: 인디케이터 추가
            
            //MARK: 상단 텍스트
            Text("지원자로부터\n수집할 정보를 선택해주세요")
                .font(.system(size: 24))
            Spacer().frame(height: 16)
            
            HStack {
                Image(systemName: "exclamationmark.circle")
                    .font(.system(size: 16))
                Text("모집글 작성이 완료되면 수정할 수 없어요")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
            
            Spacer().frame(height: 40)
            
            //MARK: 기본 정보 체크
            TextWithDescription(MainText: "기본 정보")
            ForEach(RecruitmentField.allCases) { field in
                BasicInfoSelectionItemView(
                    field: field,
                    text: .constant(field.rawValue),
                    IsChecked: Binding(
                        get: { viewModel.basicInfoChecked[field] ?? false },
                        set: { viewModel.basicInfoChecked[field] = $0 }
                    )
                )
            }
        } //: VSTACK
        .frame(maxWidth: .infinity)
    }
}
