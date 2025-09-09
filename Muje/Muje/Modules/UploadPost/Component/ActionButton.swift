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
        Text(title)
            .body1SemiBold16()
            .foregroundStyle(condition ? .gray400 : .graywhite)
            .padding(.horizontal, 14.5)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(condition ? .gray300 : .primaryBlack)
            )
    }
}
