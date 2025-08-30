//
//  InterviewButton.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI

struct InterviewButton: View {
    var condition: Bool? = nil
    var value: Bool
    var title: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.2))
            .stroke(condition == value ? Color.purple : Color.clear, lineWidth: 1)
            .frame(height: 56)
            .overlay(content: {
                Text(title)
                    .foregroundStyle(condition == value ? Color.purple : Color.secondary)
                    .bold()
            })
    }
}

#Preview {
    InterviewButton(value: false, title: "qwer")
}
