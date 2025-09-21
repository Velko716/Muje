//
//  DeleteAccountReauthView.swift
//  Muje
//
//  Created by 김진혁 on 9/21/25.
//

import SwiftUI

// TODO: 패스워드 틀릴 시 포커스 스테이트랑 토스트 메시지 추가하기
struct DeleteAccountReauthView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    @State private var viewModel: DeleteAccountReauthViewModel = .init()
    
    @State private var password: String = ""
    @State private var showConfirmWithdraw: Bool = false
    @State private var showToastMessage: Bool = false
    
    @State private var isPasswordVerified = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Spacer().frame(height: 24)
                topTitleView
                Spacer().frame(height: 48)
                middleInputPasswordView
                Spacer()
            }
        }
        .paddingH16()
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "확인",
                    textColor: .white,
                    bgColor: Color.primaryBlack,
                    enabled: !password.isEmpty,
                ) {
                    dismissKeyboard()
                    showConfirmWithdraw = true
                }
            }
            .bottomBarBackground()
            .padding(.bottom, 8)
            .toast(isPresented: $showToastMessage, duration: 2, position: .bottom) {
                ToastView(text: "비밀번호가 올바르지 않아요. 다시 입력해주세요")
                    .offset(y: -60)
            }
        }
        .overlay(alignment: .bottom) {
            if showConfirmWithdraw {
                BottomConfirmSheet(
                    title: "정말로 탈퇴하시겠습니까?\n작성한 공고와 채팅 기록이 모두 삭제됩니다",
                    primaryTitle: "탈퇴",
                    onPrimary: {
                        Task {
                            do {
                                try await viewModel.deleteAuth(
                                    email: FirebaseAuthManager.shared.currentEmail,
                                    password: password
                                )
                                router.popToRootView()
                                showConfirmWithdraw = false
                            }
                            catch {
                                showConfirmWithdraw = false
                                isPasswordVerified = true
                                showToastMessage = true
                                print("error: \(error.localizedDescription)")
                            }
                        }
                    },
                    onCancel: { showConfirmWithdraw = false },
                    showWarning: true
                )
            }
        }
        .animation(.easeInOut(duration: 0.22), value: showConfirmWithdraw)
        .toolbar {
            ToolbarLeadingXmarkBackButton()
            ToolbarCenterTitle(text: "비밀번호 인증")
        }
    }
    
    // MARK: - 탑 타이틀 뷰
    private var topTitleView: some View {
        Text("탈퇴를 위해 비밀번호를 입력해주세요")
            .font(Font.pretendard(type: .semiBold, size: 24))
            .foregroundStyle(Color.gray700)
    }
    
    // MARK: - 미들 비밀번호 입력 뷰
    private var middleInputPasswordView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("계정 비밀번호")
                .font(Font.pretendard(type: .semiBold, size: 14))
                .foregroundStyle(Color.gray700)
                .offset(x: 4)
            
            RoundedTextField(
                text: $password,
                placeholder: "계정 비밀번호를 입력해주세요",
                keyboard: .default,
                isSecure: true
            )
            
            if isPasswordVerified {
                Text("비밀번호가 올바르지 않아요")
                    .font(Font.pretendard(type: .medium, size: 14))
                    .foregroundStyle(Color.accentRed)
                    .offset(x: 4)
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        DeleteAccountReauthView()
    }
}
