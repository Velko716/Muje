//
//  SwiftUIView.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import SwiftUI

struct EmailVerificationView : View {
    @EnvironmentObject private var auth: FirebaseAuthManager
    
    @State private var viewModel: EmailVerificationViewModel = .init()
    @State private var emailText: String = "" // 이메일 입력
    @State private var passwordText: String = "" // 패스워드 입력
    @State private var rePasswordText: String = "" // 패스워드 재 입력
    @State private var bottomBarText: String = "인증 요청"
    @State private var showToastMessage: Bool = false
    
    // 이메일 검증에 따라 UI 랜더링
    // @State private var verified = FirebaseAuthManager.shared.emailVerified
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 48) {
                topTitleView
                middleInputEmailTextFieldView
                bottomPasswordTextFieldView
                Spacer()
            }
            .paddingH16()
        }
        // TODO: 컴포넌트로 이 뷰를 만들기
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: bottomBarText,
                    textColor: Color.white,
                    bgColor: Color.black,
                    enabled: emailText.isEmpty ? false : false
                ) {
                    self.bottomBarText = "인증 확인"
                    self.showToastMessage = true
                    viewModel.sendVerificationEmail(emailText: emailText)
                }
            }
            .toast(
                isPresented: $showToastMessage,
                duration: 2,
                position: .bottom
            ) {
                ToastView(text: "인증 요청 이메일을 보냈어요!\n메일함 확인 후, 인증 확인 버튼을 눌러주세요")
                    .offset(y: -60)
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
                placeholder: "@jbnu.ac.kr",
                keyboard: .emailAddress
            )
            
            if auth.emailVerified {
                Text("이메일 인증을 성공했어요")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
                    .offset(x: 4)
            }
        }
    }
    
    
    // MARK: - 바텀 패스워드 텍스트 필드 뷰 (이메일 검증 완료 시)
    private var bottomPasswordTextFieldView: some View {
        VStack(alignment: .leading) {
            if auth.emailVerified {
                Text("비밀번호")
                    .font(Font.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                    .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
                    .offset(x: 4)
                Spacer().frame(height: 8)
                RoundedTextField(
                    text: $passwordText,
                    placeholder: "비밀번호를 6자리 이상 입력해주세요",
                    keyboard: .default,
                    isSecure: true
                )
                Spacer().frame(height: 24)
                Text("비밀번호 확인")
                    .font(Font.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                    .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
                    .offset(x: 4)
                Spacer().frame(height: 8)
                RoundedTextField(
                    text: $rePasswordText,
                    placeholder: "비밀번호를 다시 입력해주세요",
                    keyboard: .default,
                    isSecure: true
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmailVerificationView()
            .environmentObject(FirebaseAuthManager.shared)
    }
}
