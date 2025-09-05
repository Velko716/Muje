//
//  ForgotPasswordView.swift
//  Muje
//
//  Created by 김진혁 on 9/4/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    @State private var viewModel: ForgotPasswordViewModel = .init()
    @State private var email: String = ""
    
    @State private var showErrorMessage: Bool = false
    @State var showToastMessage: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 48) {
                topTitleView
                    .frame(maxWidth: .infinity, alignment: .leading)
                middleEmailInputView
                Spacer()
            }
            
        }
        .toolbar {
            ToolbarLeadingXmarkBackButton()
            ToolbarCenterTitle(text: "")
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "비밀번호 초기화",
                    textColor: .white,
                    bgColor: .black,
                    enabled: !email.isEmpty
                ) {
                    Task {
                        do {
                            try await viewModel.sendPasswordReset(email: email)
                            await MainActor.run { showToastMessage = true }
                            try? await Task.sleep(for: .seconds(1.5)) // FIXME: - 토스트 메세지를 띄우기 위한 임시 초 맞추기
                            await MainActor.run { router.pop() }
                        } catch {
                            await MainActor.run {
                                self.showErrorMessage = true
                            }
                        }
                    }
                }
            }
            .toast(isPresented: $showToastMessage, duration: 2, position: .bottom) {
                ToastView(text: "비밀번호 재설정 링크를 보냈어요.\n메일함을 확인해 주세요.")
                    .offset(y: -60)
            }
            .bottomBarBackground()
        }
        .paddingH16()
    }
    
    // MARK: - 탑 타이틀 뷰
    private var topTitleView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("가입한 대학교 이메일을 입력해주세요")
                .font(Font.system(size: 24, weight: .semibold)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.black) // FIXME: - 컬러 수정
            Text("입력한 이메일로 새로운 비밀번호를 보내드려요.")
                .font(Font.system(size: 16, weight: .medium)) // FIXME: - 폰트 수정
                .foregroundStyle(Color.gray) // FIXME: - 폰트 수정
        }
    }
    
    // MARK: - 미들 이메일 주소 입력 창 뷰
    private var middleEmailInputView: some View {
        VStack(alignment: .leading, spacing: 4) {
            RoundedTextField(
                text: $email,
                placeholder: "이메일 주소",
                keyboard: .emailAddress
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(showErrorMessage ? Color.red : .clear, lineWidth: 1)
            }
            
            if showErrorMessage {
                Text("존재하지 않는 이메일이에요")
                    .font(Font.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.red) // FIXME: - 컬러 수정
                    .offset(x: 7)
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
}
