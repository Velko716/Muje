//
//  SwiftUIView.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import SwiftUI

struct EmailVerificationView : View {
    
    @State private var viewModel: EmailVerificationViewModel = .init()
    @State private var emailText: String = ""
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                topTitleView
                Spacer().frame(height: 48)
                middleInputEmailTextFieldView
                Spacer()
            }
            .paddingH16()
        }
        // TODO: 컴포넌트로 이 뷰를 만들기
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "인증 요청",
                    textColor: Color.white,
                    bgColor: Color.black,
                    enabled: emailText.isEmpty ? true : false
                ) {
                    viewModel.sendVerificationEmail(emailText: emailText)
                }
            }
            .bottomBarBackground() // ViewModifier
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: "회원가입")
        }
    }
    
    
    // MARK: - 탑 이메일 인증 타이틀 뷰
    private var topTitleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.blue) // FIXME: - 컬러 수정
                        .frame(width: 24, height: 24)
                        .overlay(alignment: .center) {
                            Text("1")
                                .font(Font.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                                .foregroundStyle(Color.white) // FIXME: - 컬러 수정
                                .monospacedDigit() // 숫자(0–9)만 고정 폭(tabular)으로 보이게 하는 SwiftUI 텍스트 모디파이어
                                .frame(width: 24, height: 24, alignment: .center)
                        }
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 10, height: 10)
                }
                Text("학교 인증을 위해서\n대학교 이메일을 입력해주세요.")
                    .font(Font.system(size: 24, weight: .semibold)) // FIXME: - 폰트 수정
                    .foregroundStyle(Color.black) // FIXME: - 컬러 수정
            }
            Spacer()
        }
    }
    
    
    // MARK: - 미들 이메일 입력 텍스트 필드 뷰
    private var middleInputEmailTextFieldView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("대학교 이메일")
                .font(Font.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.black) // FIXME: - 컬러 수정
                .offset(x: 4)
            
            RoundedTextField(
                text: $emailText,
                keyboard: .emailAddress
            )
        }
    }
    
    // MARK: - 바텀 아래 인증 요청 뷰
    private var bottomButtonView: some View {
        VStack {
            Button {
                viewModel.sendVerificationEmail(emailText: emailText)
            } label: {
                Text("인증 요청")
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmailVerificationView()
    }
}
