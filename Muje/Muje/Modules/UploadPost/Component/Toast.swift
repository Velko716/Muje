//
//  Toast.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct Toast: View {
    @Binding var isShown: Bool
    var message: String = "message"
    
    var body: some View {
        VStack {
          Spacer()
            if isShown {
                HStack(spacing: 16) {
                    Text(message)
                        .foregroundStyle(Color.white)
                }
                .hvPadding(16, 10)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.6)))
                .transition(.move(edge: .bottom))
            }
        }
        .padding(.bottom, 150)
    }
}

#Preview {
    Toast(isShown: .constant(true))
}
