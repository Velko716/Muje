//
//  TopBarPrincipalTitle.swift
//  Muje
//
//  Created by 김진혁 on 8/20/25.
//

import SwiftUI

struct ToolbarCenterTitle: ToolbarContent {
    let text: String
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(text)
                .font(Font.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {
    NavigationStack {
        Text("Preview")
            .toolbar {
                ToolbarCenterTitle(text: "안녕하세요")
            }
    }
}
