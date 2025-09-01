//
//  SwiftUIView.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import SwiftUI
import FirebaseAuth

struct EmailVerificationView: View {
    @EnvironmentObject private var auth: FirebaseAuthManager
    @EnvironmentObject private var router: NavigationRouter
    
    @State private var viewModel: EmailVerificationViewModel = .init()
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private   var rePasswordText: String = ""
    @State private var showToastMessage = false
    
    // 포커스 & 에러 노출 제어
    @FocusState private var focused: Field?
    private enum Field { case password, confirm }
    @State private var passwordTouched = false
    @State private var confirmTouched  = false
    
    // 단계는 emailVerified로 파생
    private var isPasswordStep: Bool { auth.emailVerified }
    
    // 라벨/유효성
    private var bottomLabel: String { isPasswordStep ? "다음" : "인증 요청" }
    private var isPasswordValid: Bool { passwordText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 6 }
    private var isConfirmValid: Bool {
        !rePasswordText.isEmpty && rePasswordText == passwordText
    }
    
    // 에러 메시지(입력 건드린 이후에만 노출)
    private var passwordError: String? {
        guard passwordTouched else { return nil }
        return isPasswordValid ? nil : "6자리 이상 입력해주세요"
    }
    private var confirmError: String? {
        guard confirmTouched else { return nil }
        return isConfirmValid ? nil : "비밀번호가 일치하지 않습니다"
    }
    
    var body: some View {
        ZStack {
            Color.white
            VStack(spacing: 48) {
                topTitleView
                emailSection
                passwordSection
                Spacer()
            }
            .paddingH16()
        }
        .onDisappear { FirebaseAuthManager.shared.emailVerified = false }
        .onChange(of: auth.emailVerified) { withAnimation(.easeInOut) {} }
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: bottomLabel,
                    textColor: .white,
                    bgColor: .black,
                    enabled: emailText.isEmpty ? false : true
                ) {
                    if isPasswordStep {
                        // 비번 단계: 실패 시 첫 에러 필드로 포커스
                        passwordTouched = true
                        confirmTouched  = true
                        guard isPasswordValid else { focused = .password; return }
                        guard isConfirmValid  else { focused = .confirm;  return }
                        
                        if let uid = Auth.auth().currentUser?.uid {
                            router.push(to: .userInfoInputView(uuid: uid, email: FirebaseAuthManager.shared.email))
                            FirebaseAuthManager.shared.email = ""
                        }
                    } else {
                        showToastMessage = true
                        viewModel.sendVerificationEmail(emailText: emailText)
                    }
                }
                .bottomBarBackground()
            }
            .toast(isPresented: $showToastMessage, duration: 2, position: .bottom) {
                ToastView(text: "인증 요청 이메일을 보냈어요!\n메일함 확인 후, 인증 확인 버튼을 눌러주세요")
                    .offset(y: -60)
            }
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: "회원가입")
        }
    }
    
    // MARK: - 상단
    private var topTitleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Circle().fill(Color.blue).frame(width: 24, height: 24)
                        .overlay { Text("1")
                                .font(.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                                .foregroundStyle(.white) // FIXME: - 컬러 수정
                        }
                    Circle().fill(Color.gray).frame(width: 10, height: 10)
                }
                Text("학교 인증을 위해서\n대학교 이메일을 입력해주세요.")
                    .font(.system(size: 24, weight: .semibold)) // FIXME: - 폰트 수정
                    .foregroundStyle(.black) // FIXME: - 컬러 수정
            }
            Spacer()
        }
    }
    
    // MARK: - 이메일 섹션
    private var emailSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("대학교 이메일")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.black)
                .offset(x: 4)
            
            RoundedTextField(
                text: $emailText,
                placeholder: "@jbnu.ac.kr",
                keyboard: .emailAddress
            )
            .disabled(isPasswordStep)
            
            if auth.emailVerified {
                Text("이메일 인증을 성공했어요")
                    .font(.system(size: 14, weight: .medium)) // FIXME: - 폰트 수정
                    .foregroundStyle(.blue) // FIXME: - 컬러 수정
                    .offset(x: 4)
            }
        }
    }
    
    // MARK: - 비밀번호 섹션
    private var passwordSection: some View {
        Group {
            if isPasswordStep {
                VStack(alignment: .leading, spacing: .zero) {
                    // 비밀번호
                    Text("비밀번호")
                        .font(.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                        .foregroundStyle(.gray) // FIXME: - 컬러 수정
                        .offset(x: 4)
                    
                    Spacer().frame(height: 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedTextField(
                            text: $passwordText,
                            placeholder: "비밀번호를 6자리 이상 입력해주세요",
                            keyboard: .default,
                            isSecure: true
                        )
                        .focused($focused, equals: .password)
                        .textContentType(.newPassword)
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(passwordError == nil ? Color.gray.opacity(0.3) : .red, lineWidth: 1)
                        }
                        .onChange(of: passwordText) { _, _ in passwordTouched = true }
                        
                        if let msg = passwordError {
                            Text(msg)
                                .font(.system(size: 14, weight: .medium)) // FIXME: - 폰트 수정
                                .foregroundStyle(.red) // FIXME: - 컬러 수정
                                .offset(x: 4)
                        }
                    }
                    
                    Spacer().frame(height: 24)
                    
                    // 비밀번호 확인
                    Text("비밀번호 확인")
                        .font(.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                        .foregroundStyle(.gray) // FIXME: - 컬러 수정
                        .offset(x: 4)
                    
                    Spacer().frame(height: 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedTextField(
                            text: $rePasswordText,
                            placeholder: "비밀번호를 다시 입력해주세요",
                            keyboard: .default,
                            isSecure: true
                        )
                        .focused($focused, equals: .confirm)
                        .textContentType(.password)
                        .keyboardType(.asciiCapable)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(confirmError == nil ? Color.gray.opacity(0.3) : .red, lineWidth: 1)
                        }
                        .onChange(of: rePasswordText) { _, _ in confirmTouched = true }
                        
                        if let msg = confirmError {
                            Text(msg)
                                .font(.system(size: 12)) // FIXME: - 폰트 수정
                                .foregroundStyle(.red) // FIXME: - 컬러 수정
                                .offset(x: 4)
                        }
                    }
                }
                .animation(.easeInOut, value: isPasswordStep)
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
