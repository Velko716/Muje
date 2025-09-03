//
//  TextView.swift
//  Muje
//
//  Created by 김진혁 on 8/27/25.
//

import SwiftUI

struct TextView: View {
    @Bindable var viewModel: TextViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.text)
                    .foregroundStyle(Color.black) // FIXME: - 컬러 수정, 폰트 추가하기
                Spacer()
            }
            .paddingH16()
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: viewModel.title)
        }
    }
}

#Preview {
    NavigationStack {
        TextView(viewModel: TextViewModel(type: .communityRule))
    }
}
