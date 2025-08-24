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
    let thumbnailImage: UIImage?
    
    var body: some View {
        HStack {
            
            // MARK: 상단 - 동아리명
            VStack(alignment: .leading){
                //FIXME: 에셋 추가되면 폰트 수정
                Text(post.organization)
                    .fontWeight(.medium)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(red: 0.53, green: 0.53, blue: 0.53))
                Spacer().frame(height: 4)
                
                // MARK: 중간 - 제목
                Text(post.title)
                    .fontWeight(.semibold)
                    .font(.system(size: 18))
                    .lineSpacing(8)
                    .lineLimit(2)
                
                Spacer()
                
                // MARK: 하단 - 모집 상태
                Text(post.status)
                    .fontWeight(.medium)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(red: 0.66, green: 0.66, blue: 0.66))
            } //: VSTACK
            .padding(.vertical, 20)
            .frame(height: 152)
            
            Spacer()
            
            // MARK: 우측 - 사진 (미리보기)
            if let thumbnailImage = thumbnailImage {
                Image(uiImage: thumbnailImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 78, height: 78)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 78, height: 78)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
        } //: HSTACK
        .contentShape(Rectangle())
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
    }
    
}
