//
//  PageController.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct PageController: View {
    var pageCount: Int
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            Spacer()
            
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.blue : Color.blue.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
            Spacer()
        }
    }
}

#Preview {
    PageController(pageCount: 3, currentPage: .constant(.init(1)))
}
