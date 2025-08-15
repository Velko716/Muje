//
//  InboxNavigationChip.swift
//  Muje
//
//  Created by 김진혁 on 8/15/25.
//

import SwiftUI

struct InboxNavigationChip: View {
    let type: InboxNavigationChipType
    
    var body: some View {
        RoundedRectangle(cornerRadius: 200)
            .fill(type.color)
            .overlay {
                Text(type.displayName)
            }
    }
}

#Preview {
    InboxNavigationChip(type: .applicant)
        .frame(width: 61, height: 25)
    
    InboxNavigationChip(type: .recruiter)
        .frame(width: 61, height: 25)
}
