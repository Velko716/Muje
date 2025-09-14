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
            .fill(condition == value ? .pointSkyBlueTinted : .gray50)
            .stroke(condition == value ? .pointSkyBlue : Color.clear, lineWidth: 1)
            .frame(height: 56)
            .overlay(content: {
                Text(title)
                    .foregroundStyle(condition == value ? .pointSkyBlue : .gray700)
                    .body1SemiBold18()
            })
    }
}

#Preview {
    InterviewButton(value: false, title: "qwer")
}
