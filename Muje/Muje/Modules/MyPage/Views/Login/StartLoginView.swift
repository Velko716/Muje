//
//  StartLoginView.swift
//  Muje
//
//  Created by 김진혁 on 8/31/25.
//

import SwiftUI

struct StartLoginView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                topApplogoView
                Spacer().frame(height: 39)
                middleServiceNameView
            }
        }
        // TODO: 컴포넌트로 이 뷰를 만들기
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "시작하기",
                    textColor: Color.white,
                    bgColor: Color.primaryBlack,
                    enabled: true
                ) {
                    router.push(to: .emailVerificationView)
                }
                
                Spacer().frame(height: 16)
                
                Text("이미 가입하신적이 있으신가요?")
                    .font(Font.pretendard(type: .medium, size: 14))
                    .foregroundStyle(Color.gray700)
                
                Spacer().frame(height: 4)
                
                Button {
                    router.push(to: .loginView)
                } label: {
                    Text("로그인하기")
                        .font(Font.pretendard(type: .medium, size: 14))
                        .foregroundStyle(Color.pointSkyBlue)
                }
            }
            .bottomBarBackground() // ViewModifier
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: "시작하기")
        }
    }
    
    // MARK: - 탑 앱 로고 이미지 (임시)
    // FIXME: - 앱 로고 업데이트 하기
    private var topApplogoView: some View {
        Rectangle()
            .fill(Color.gray)
            .overlay {
                VStack {
                    Text("앱 로고")
                        .font(Font.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.black)
                    Text("or 그래픽")
                        .font(Font.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.black)
                }
            }
            .frame(width: 234, height: 207)
    }
    
    
    // MARK: - 미들 서비스 네임 뷰
    // FIXME: - 서비스 이름 업데이트 하기
    private var middleServiceNameView: some View {
        VStack(spacing: 19) {
            Text("[서비스 네임]")
                .font(Font.pretendard(type: .semiBold, size: 24))
                .foregroundStyle(Color.gray700)
            
            Text("[브랜드 슬로건, UX라이팅]")
                .font(Font.pretendard(type: .semiBold, size: 18))
                .foregroundStyle(Color.gray700)
        }
    }
    
}

#Preview {
    NavigationStack {
        StartLoginView()
            .environmentObject(NavigationRouter())
    }
}
