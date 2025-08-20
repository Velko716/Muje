//
//  RecruitmentSelectionItemView.swift
//  Muje
//
//  Created by 김서현 on 8/20/25.
//

import SwiftUI

struct RecruitmentSelectionItemView: View {
    let IsBasicInfo: Bool
    var text: String
    @State var IsChecked: Bool = false
    
    var body: some View {
        Button {
            IsChecked.toggle()
        } label: {
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundStyle(IsChecked ? Color.blue : Color.gray)
                Spacer()
                if IsBasicInfo {
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.2))
                        .frame(width: 26, height: 26)
                        .overlay(IsChecked ? Image(.checkCircle) : nil)
                }
            } //: HSTACK
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background (
                RoundedRectangle(cornerRadius: 10)
                    .stroke(IsChecked ? Color.blue : Color.gray, lineWidth: 1)
                    .fill(IsChecked ? Color.blue.opacity(0.2) : Color.clear)
            )
        }

    }
}

#Preview {
    RecruitmentSelectionItemView(IsBasicInfo: true, text: "지원자 이름", IsChecked: true)
}
