//
//  RegistrationCompleteView.swift
//  Muje
//
//  Created by 김진혁 on 9/3/25.
//

import SwiftUI

struct RegistrationCompleteView: View {
    // FIXME: - 피그마랑 변수 처리가 다름 (디자이너와 논의) => 피그마: 성x 이름o, 로직: 성o 이름oo
    let userName: String
    
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        ZStack() {
            VStack() {
                topTitleView
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 116)
                middleGraphicView
                Spacer()
            }
        }
        .paddingH16()
        // TODO: 컴포넌트로 이 뷰를 만들기
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "확인",
                    textColor: Color.white,
                    bgColor: Color.black,
                    enabled: true
                ) {
                    router.popToRootView() // 전체 뒤로가기
                }
            }
            .bottomBarBackground() // ViewModifier
        }
        .toolbar {
            ToolbarLeadingXmarkBackButton() {
                router.popToRootView() // 전체 뒤로가기
            }
            ToolbarCenterTitle(text: "회원가입")
        }
    }
    
    // MARK: - 탑 타이틀 뷰
    private var topTitleView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(userName)님 환영해요!\n회원가입이 완료되었어요")
                .font(Font.system(size: 24, weight: .semibold)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.black) // FIXME: - 컬러 수정
            Text("나에게 딱 맞는 사람들과 모임을 함께 찾아보아요")
                .font(Font.system(size: 16, weight: .regular))
                .foregroundStyle(Color.gray)
        }
    }
    
    // MARK: - 미들 그래픽 뷰
    // FIXME: - 그래픽 추가하기
    private var middleGraphicView: some View {
        Rectangle()
            .fill(Color.gray)
            .overlay {
                Text("그래픽")
                    .font(Font.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.black)
            }
            .frame(width: 234, height: 207)
    }
    
}

#Preview {
    NavigationStack {
        RegistrationCompleteView(userName: "재훈")
    }
}
