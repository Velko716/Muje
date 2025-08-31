//
//  ToastView.swift
//  Muje
//
//  Created by 김진혁 on 8/31/25.
//

import SwiftUI

struct ToastView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.black.opacity(0.6))
            )
            .padding(.horizontal, 47)
    }
}

#Preview {
    ToastView(text: "하이요")
}
