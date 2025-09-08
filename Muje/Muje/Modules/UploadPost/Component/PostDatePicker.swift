//
//  PostDatePicker.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct PostDatePicker: View {
    let title: String
    let content: String
    let function: () -> Void
    
    @State var isSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(title)
                    .caption14SemiBold()
                    .foregroundStyle(.gray700)
                Text("추후 설정 가능")
                    .caption14Regular()
                    .foregroundStyle(.gray500)
            }
            
            Button(action: {
                function()
            }, label: {
                HStack(spacing: 6) {
                    Text(content)
                        .body2Medium16()
                        .foregroundStyle(isSelected ? .gray700 : .gray500)
                    Spacer()
                    Image(.calendarIcon)
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray50)
                )
                .onChange(of: content, { old, new in
                    isSelected = true
                })
            })
        }
    }
}

#Preview {
    PostDatePicker(title: "마감일 선택", content: "asdfs", function: {print("S")}, isSelected: true)
}
