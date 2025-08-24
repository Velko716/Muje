//
//  BasicInfoSelectionItemView.swift
//  Muje
//
//  Created by 김서현 on 8/24/25.
//

import SwiftUI

struct BasicInfoSelectionItemView: View {

    let field: RecruitmentField
    
    @Binding var text: String
    @Binding var IsChecked: Bool
    @FocusState var IsTyping: Bool
    
    var body: some View {
        Button {
            withAnimation(.none){
                // 지원자 이름은 항상 check 되어 있음
                if field != .name {
                    IsChecked.toggle()
                }
            }
        } label: {
            
            HStack {
                Text(text)
                    .font(.system(size: 16))
                    .foregroundStyle(IsChecked ? Color.blue : Color.gray)
                Spacer()
                Circle()
                    .strokeBorder(Color.gray.opacity(0.2))
                    .frame(width: 26, height: 26)
                    .overlay(
                        text == "지원자 이름"
                        ? Image(.essentialCircle)
                        : (IsChecked ? Image(.checkCircle) : nil)
                    )
                
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
