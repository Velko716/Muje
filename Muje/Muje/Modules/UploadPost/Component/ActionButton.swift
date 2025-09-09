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
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14.5)
                .background(condition ? .gray300 : .primaryBlack)
                .foregroundStyle(condition ? .gray400 : .graywhite)
                .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
