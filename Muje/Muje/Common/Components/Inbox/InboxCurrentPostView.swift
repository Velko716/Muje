//
//  InboxCurrentPostView.swift
//  Muje
//
//  Created by 김진혁 on 8/15/25.
//

import SwiftUI

struct InboxCurrentPostView: View {
    
    let title: String
    
    var body: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 4) // FIXME: - 공고 이미지로 수정
                .fill(Color.gray200)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("동아리명")
                    .font(Font.pretendard(type: .medium, size: 14))
                    .foregroundStyle(Color.gray500)
                Text(title)
                    .font(Font.pretendard(type: .semiBold, size: 14))
                    .foregroundStyle(Color.gray700)
            }
        }
    }
}

#Preview {
    InboxCurrentPostView(title: "댄스월드 연합 댄스 동아리💃 춤도 추고 친목도 다질 사람 모여라🙌")
}
