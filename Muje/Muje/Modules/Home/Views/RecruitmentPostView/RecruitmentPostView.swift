//
//  RecruitmentPostView.swift
//  Muje
//
//  Created by 김서현 on 8/21/25.
//

import SwiftUI

struct RecruitmentPostView: View {
    @State var typingText = ""
    var body: some View {
        RecruitmentSelectionItemView(IsBasicInfo: true, text: "지원자 이름")
        RecruitmentSelectionItemView(IsBasicInfo: false, text: "" )
    }
}

#Preview {
    RecruitmentPostView()
}
