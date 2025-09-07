//
//  divider.swift
//  Muje
//
//  Created by 김서현 on 9/5/25.
//

import SwiftUI

struct divider: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(.gray50)
                .frame(maxWidth: .infinity)
                .frame(height: 12)
                .padding(.horizontal, -16)
        }
        .padding(.vertical, 24)
    }
}

#Preview {
    divider()
}
