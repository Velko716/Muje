//
//  ButtonBox.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct ButtonBox: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Rectangle()
                .fill(Color.clear)
                .frame(height: 36)
                .overlay(content: {
                    Text(title)
                        .foregroundStyle(Color.black)
                })
        })
    }
}

#Preview {
    ButtonBox(title: "면접 일정", action: { print("면접 일정 관리 페이지로 이동") })
}
