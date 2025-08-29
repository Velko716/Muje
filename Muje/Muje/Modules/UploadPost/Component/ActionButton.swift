//
//  ActionButton.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct ActionButton: View {
    var title: String
    var condition: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(condition ? Color.gray.opacity(0.2) : Color.black)
            .frame(height: 56)
            .overlay(content: {
                Text(title)
                    .foregroundStyle(condition ? Color.secondary : Color.white)
                    .bold()
            })
    }
}
