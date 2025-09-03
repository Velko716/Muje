//
//  StatusChip.swift
//  Muje
//
//  Created by 김서현 on 9/2/25.
//

import SwiftUI

struct StatusChip: View {
    var status : RecruitmentStatus
    var body: some View {
        Text(status.text)
            .foregroundStyle(status.textColor)
            .caption14SemiBold()
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(status.backgroundColor)
            )
    }
}
