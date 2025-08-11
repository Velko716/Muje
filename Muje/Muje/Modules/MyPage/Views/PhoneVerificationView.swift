//
//  PhoneVerificationView.swift
//  Muje
//
//  Created by 김진혁 on 8/7/25.
//

import SwiftUI

struct PhoneVerificationView: View {
    @State private var phoneNumber: String = "" // 임시
    @State private var verificationCode: String = "" // 임시
    
//    @Bindable var phoneVM: PhoneVerificationViewModel
    
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        VStack(spacing: 40) {
            topTitleView
            middleInputPhoneNumberView
            middleVerificationCode
            requiredConsent
            bottomNextButtonView
        }
        .paddingH16()
    }
    
    // MARK: - 상단 타이틀 뷰
    private var topTitleView: some View {
        VStack(alignment: .leading) {
            Text("사용자 인증을 위해\n전화번호를 입력해주세요.(3/3)")
                .font(.title3)
        }
    }
    
    // MARK: - 중간 핸드폰 번호 입력 뷰
    private var middleInputPhoneNumberView: some View {
        VStack(alignment: .leading) {
            TextField("전화번호를 입력해주세요", text: $phoneNumber)
            
            // TODO: 인증 시작 버튼(디자이너에게 물어보기)
            Button {
//                let phoneNumber = phoneVM.formatPhoneNumberToKorean(phoneNumber)
//                phoneVM.requestPhoneVerification(phoneNumber: phoneNumber)
            } label: {
                Text("인증 요청 하기")
            }
            .frame(height: 100)
        }
    }
    
    // MARK: - 중간 인증번호 입력 뷰
    private var middleVerificationCode: some View {
        VStack {
            TextField("인증번호를 입력해주세요", text: $verificationCode)
            // TODO: 10분 타이머를 추가해야함 (파이어베이스 전화 인증 유효시간은 10분)
        }
    }
    
    // MARK: - 이용약관 뷰
    private var requiredConsent: some View {
        VStack(spacing: 8) {
            RequiredConsentButton(title: "[필수] 이용약관에 동의합니다.") {
                // TODO: 약관동의 체크 확인
            } navigationAction: {
                // TODO: 디테일 약관동의 뷰로 이동
            }
            
            RequiredConsentButton(title: "[필수] 개인정보 처리방침에 동의합니다.") {
                // TODO: 개인정보 처리방침 체크 확인
            } navigationAction: {
                // TODO: 디테일 개인정보 처리방침 뷰로 이동
            }
        }
    }
    
    // MARK: - 바텀 다음 버튼 뷰
    private var bottomNextButtonView: some View {
        VStack {
            Button {
                // TODO: 위 로직에 따라 Bool 값에 따라 파이어베이스에 유저 저장, 혹은 실패 처리로 구현
                Task {
                    do {
//                        let ok = try await FirebaseAuthManager.shared.verifyPhoneCodeAndSignOut(
//                            id: phoneVM.verificationID ?? "",
//                            code: verificationCode
//                        )
                        
//                        if ok {
                            
                            // signUpContainer.phoneNumber = phoneNumber
                            
                            //let created = try await signUpContainer.createUserInFirestore(with: phoneNumber)
                            //print("createUser: \(created)")
                            
                            router.popToRootView()
                            
//                            let birth = Int(signUpContainer.userInfoVM.birthYear) ?? 0
//                            let user = User(
//                                userId: UUID(),
//                                email: signUpContainer.emailVM.emailText,
//                                name: signUpContainer.userInfoVM.name,
//                                birthYear: birth,
//                                gender: signUpContainer.userInfoVM.gender,
//                                department: signUpContainer.userInfoVM.department,
//                                studentId: signUpContainer.userInfoVM.studentId,
//                                phone: phoneNumber,
//                                emailVerified: signUpContainer.emailVerified,
//                                phoneVerified: signUpContainer.phoneVerified,
//                                termsAgreed: signUpContainer.termsAgreed,
//                                privacyAgreed: signUpContainer.privacyAgreed
//                            )
//                            let createUser = try await FirestoreManager.shared.create(user)
//                            print("createUser : \(createUser)")
//                        }
//                        else {
//                            print("인증번호가 틀렸다는 UI표시하기")
//                        }
                    } catch {
                        print("error: \(error.localizedDescription)")
                    }
                }
            } label: {
                Text("다음")
                    .font(.subheadline)
                    .foregroundStyle(Color.black)
                    .bold()
                    .background(
                        Color.blue
                            .padding()
                    )
            }
        }
    }
}

#Preview {
    PhoneVerificationView()
    .environmentObject(NavigationRouter())
}
