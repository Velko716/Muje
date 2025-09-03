//
//  RecruitmentInfo.swift
//  Muje
//
//  Created by 김서현 on 9/3/25.
//

import SwiftUI

struct RecruitmentInfo: View {
    var info: String
    var content: String
    var body: some View {
        HStack(spacing: 16) {
            Text(info)
                .body2_16SemiBold()
                .foregroundStyle(.gray400)
            Text(content)
                .body2_16SemiBold()
                .foregroundStyle(.gray700)
        }
    }
}
