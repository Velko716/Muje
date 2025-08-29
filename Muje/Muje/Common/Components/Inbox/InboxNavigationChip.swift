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
        
        
        Text(type.displayName)
            .font(Font.system(size: 14, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(type.color)
            .clipShape(RoundedRectangle(cornerRadius: 200))
    }
}

#Preview {
    InboxNavigationChip(type: .applicant)
        .frame(width: 61, height: 25)
    
    InboxNavigationChip(type: .recruiter)
        .frame(width: 61, height: 25)
}
