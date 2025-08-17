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
                    Text(post.organization)
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
                
                Spacer()
                
                // MARK: 우측 - 사진 (미리보기)
                Image(.temp)
                    .resizable()
                    .scaledToFit()
                    .mask {
                        RoundedRectangle(cornerRadius: 10)
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .padding(.vertical, 17)
            } //: HSTACK
            .ignoresSafeArea()
            .frame(maxWidth: .infinity)
            
            .padding(.vertical, 20)
        }
        .onAppear {
        print("🔍 PostListItem 렌더링: \(post.title)")
    }
    }

}
