//
//  PostListItem.swift
//  Muje
//
//  Created by 김서현 on 8/7/25.
//

import SwiftUI
import Firebase

struct PostListItem: View {
    let post: Post
    
    var body: some View {
        VStack {
            HStack {
                
                // MARK: 상단 - 동아리명
                VStack(alignment: .leading){
                    //FIXME: 에셋 추가되면 폰트 수정
                    Text(post.authorOrganization)
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(red: 0.53, green: 0.53, blue: 0.53))
                    Spacer().frame(height: 4)
                    
                    // MARK: 중간 - 제목
                    Text(post.title)
                        .fontWeight(.semibold)
                        .font(.system(size: 18))
                    Spacer().frame(height: 12)
                    
                    // MARK: 하단 - 모집 상태
                    Text(post.status)
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(red: 0.66, green: 0.66, blue: 0.66))
                } //: VSTACK
                Spacer(minLength: 20)
                // 정사각형 안에 이미지 넣는거 어떻게 하나 보통?
                // MARK: 우측 - 사진 (미리보기)
                // FIXME: 이미지 정사각형 어쩌고저쩌고 preference key 써서 고치겠습니다
                Image(.temp)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    //.frame(maxWidth: .infinity, maxHeight: .infinity)
            } //: HSTACK
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .padding(.horizontal, 14)
            Divider()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
        }
    }
}
