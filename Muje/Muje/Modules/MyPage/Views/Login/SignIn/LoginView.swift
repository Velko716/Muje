//
//  LoginView.swift
//  Muje
//
//  Created by 김진혁 on 9/3/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    @State private var viewModel: LoginViewModel = .init()
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showToastMessage: Bool = false
    @State private var toastText: String = "인증을 실패하였습니다.\n이메일과 비밀번호를 확인해주세요" // FIXME: - 현재는 에러메세지가 고정이지만, 추후 에러 타입에 맞게 토스트 메세지 문구를 수정하기
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 24)
                emailPasswordInputView
                Spacer().frame(height: 32)
                findPasswordView
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .paddingH16()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "로그인",
                    textColor: .white,
                    bgColor: .black,
                    enabled: email.isEmpty == false && password.isEmpty == false
                ) {
                    Task {
                        do {
                            try await viewModel.signInWithEmailPassword(email: email, password: password)
                            router.popToRootView()
                        } catch { // 아이디 패스워드 오류 or 다른 이슈
                            await MainActor.run {
                                showToastMessage = true
                            }
                        }
                    }
                }
            }
            .toast(isPresented: $showToastMessage, duration: 2, position: .bottom) {
                ToastView(text: toastText)
                    .offset(y: -60)
            }
            .bottomBarBackground()
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: "로그인")
        }
    }
    
    // MARK: - 이메일, 비밀번호 입력창
    private var emailPasswordInputView: some View {
        VStack(alignment: .leading) {
            Text("대학교 이메일")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray)
            Spacer().frame(height: 8)
            RoundedTextField(
                text: $email,
                placeholder: "@jbnu.ac.kr",
                keyboard: .emailAddress
            )
            Spacer().frame(height: 32)
            Text("비밀번호")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.gray)
            Spacer().frame(height: 8)
            RoundedTextField(
                text: $password,
                placeholder: "비밀번호 6자리 이상 입력해주세요",
                keyboard: .default,
                isSecure: true,
                overlayColorBule: true
            )
        }
    }
    
    // MARK: - 비밀번호 찾기 버튼 뷰
    private var findPasswordView: some View {
        HStack(spacing: 8) {
            Text("비밀번호가 기억나지 않으시나요?")
                .font(Font.system(size: 14, weight: .medium)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
            Button {
                router.push(to: .forgotPasswordView)
            } label: {
                Text("내 계정찾기")
                    .font(Font.system(size: 14, weight: .medium)) // FIXME: - 폰트 수정
                    .foregroundStyle(Color.gray) // FIXME: - 컬러 수정
                    .underline(true, color: Color.gray) // FIXME: - 밑줄 색상 수정
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(NavigationRouter())
    }
}
