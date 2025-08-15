//
//  InboxView.swift
//  Muje
//
//  Created by 김진혁 on 8/14/25.
//

import SwiftUI

struct InboxView: View {
    var body: some View {
        ZStack {
            VStack {
                topCurrentPostView
                Spacer()
            }
        }
        .toolbar {
            navigationToolbarItems
        }
    }
    
    // MARK: - 네비게이션 툴 바 아이템
    @ToolbarContentBuilder
    private var navigationToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                // TODO: 뒤로가기 수행
            } label: {
                Image(systemName: "chevron.left")
            }
        }
        
        ToolbarItem(placement: .principal) {
            HStack(spacing: 8) {
                Text("\(String(describing: FirebaseAuthManager.shared.currentUser?.name))")
                InboxNavigationChip(type: .applicant) // FIXME: - 쪽지 타입을 Post Firebase에서 불러오게끔 변경해야함. (임시뷰)
                    .frame(width: 61)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // TODO: 액션 시트 나오기
            } label: {
                Image(.ellipsisVertical)
            }
        }
    }
    
    // MARK: - 탑 현재 공고 뷰
    private var topCurrentPostView: some View {
        InboxCurrentPostView(title: "댄스월드 연합 댄스 동아리💃 춤도 추고 친목도 다질 사람 모여라🙌") // FIXME: - 공고 타이틀로 수정
    }
    
}

#Preview {
    NavigationStack {
        InboxView()
    }
}
