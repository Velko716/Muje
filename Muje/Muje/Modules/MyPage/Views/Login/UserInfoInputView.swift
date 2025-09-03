//
//  UserInfoInputView.swift
//  Muje
//
//  Created by 김진혁 on 8/7/25.
//

import SwiftUI

struct UserInfoInputView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    @State private var viewModel: UserInfoInputViewModel = .init()
    //    @Bindable var emailVerificationVM: EmailVerificationViewModel
    //    @Bindable var userInfoVM: UserInfoInputViewModel
    
    let uuid: String
    let email: String
    
    @State private var name: String = ""
    @State private var birthYear: String = "" // FIXME: - DTO는 Int
    @State private var gender: String = ""
    @State private var department: String = ""
    @State private var studentId: String = ""
    
    @State private var maleIsSelected: Bool = false
    @State private var femaleIsSelected: Bool = false
    
    
    @State private var showTermsView: Bool = false // 시트 열기
    @State private var showPrivacyView: Bool = false // 시트 열기
    @State private var termsAgreed: Bool = false // 서비스 이용약관 여부
    @State private var privacyAgreed: Bool = false // 개인정보 처리방침 여부
    
    var body: some View {
        ZStack {
            Color.white
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: .zero) {
                    topTitleView
                    Spacer().frame(height: 48)
                    middleInfoInputView
                    Spacer().frame(height: 94)
                }
            }
            .paddingH16()
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                BottomBar(
                    text: "확인",
                    textColor: .white,
                    bgColor: .black,
                    enabled: true
                ) {
                    let user = User(
                        userId: self.uuid,
                        email: self.email,
                        name: name,
                        birthYear: Int(birthYear) ?? 0,
                        gender: gender,
                        department: department,
                        studentId: studentId,
                        emailVerified: true,
                        termsAgreed: true,
                        privacyAgreed: true
                    )
                    
                    Task {
                        do {
                            let _ = try await FirestoreManager.shared.update(user)
                        } catch {
                            print("error : \(error.localizedDescription)")
                        }
                        router.popToRootView() // FIXME: - 임시
                    }
                }
            }
            .bottomBarBackground()
        }
        .toolbar {
            ToolbarLeadingBackButton()
            ToolbarCenterTitle(text: "회원가입")
        }
        // FIXME: - 툴 바를 위해 네비게이션 스택으로 구현했지만, 더 좋은 방법이 있는지 알아보고 수정하기
        .sheet(isPresented: $showTermsView) {
            NavigationStack {
                TermsAndPrivacyView(
                    legalDocumentType: .termsOfService,
                    termsAgreed: $termsAgreed,
                    privacyAgreed: $privacyAgreed
                )
            }
        }
        .sheet(isPresented: $showPrivacyView) {
            NavigationStack {
            TermsAndPrivacyView(
                legalDocumentType: .privacyPolicy,
                termsAgreed: $termsAgreed,
                privacyAgreed: $privacyAgreed
            )
            }
        }
    }
    
    // MARK: - 상단
    private var topTitleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    Circle().fill(Color.gray)
                        .frame(width: 10, height: 10)
                    Circle().fill(Color.blue)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Text("2")
                                .font(.system(size: 14, weight: .semibold)) // FIXME: - 폰트 수정
                                .foregroundStyle(.white) // FIXME: - 컬러 수정
                        }
                }
                Text("인적사항을 입력해주세요")
                    .font(.system(size: 24, weight: .semibold)) // FIXME: - 폰트 수정
                    .foregroundStyle(.black) // FIXME: - 컬러 수정
            }
            Spacer()
        }
    }
    
    // MARK: - 중간 유저 정보 입력 뷰
    private var middleInfoInputView: some View {
        VStack(alignment: .leading) {
            Text("이름")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            RoundedTextField(
                text: $name,
                placeholder: "이름을 입력해주세요",
                keyboard: .emailAddress
            )
            
            Spacer().frame(height: 32)
            
            Text("생년월일")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            RoundedTextField(
                text: $birthYear,
                placeholder: "생년월일 8자리를 입력해주세요",
                keyboard: .emailAddress
            )
            
            Spacer().frame(height: 32)
            
            Text("학과")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            RoundedTextField(
                text: $department,
                placeholder: "학과를 입력해주세요",
                keyboard: .emailAddress
            )
            
            Spacer().frame(height: 32)
            
            Text("학번")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            RoundedTextField(
                text: $studentId,
                placeholder: "학번을 입력해주세요",
                keyboard: .emailAddress
            )
            
            Spacer().frame(height: 32)
            
            Text("성별")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            HStack(spacing: 17) {
                GenderChoiceButton(title: "남", isSelected: maleIsSelected) {
                    maleIsSelected = true
                    femaleIsSelected = false
                    self.gender = Gender.male.rawValue
                }
                GenderChoiceButton(title: "여", isSelected: femaleIsSelected) {
                    maleIsSelected = false
                    femaleIsSelected = true
                    self.gender = Gender.female.rawValue
                }
            }
            .frame(height: 56)
            
            Spacer().frame(height: 32)
            
            Text("약관동의")
                .font(Font.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.black)
            
            Spacer().frame(height: 8)
            
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .stroke(Color.gray, lineWidth: 1)
                .overlay {
                    VStack(spacing: 8) {
                        Button {
                            self.showTermsView = true
                        } label: {
                            HStack(spacing: .zero) {
                                Text("[필수] 이용약관에 동의합니다.")
                                    .font(Font.system(size: 16, weight: .medium)) // FIXME: - 폰트 수정
                                    .foregroundStyle(termsAgreed ? Color.blue : Color.gray) // FIXME: - 컬러 수정
                                Image(.iconChevronRight)
                                    .foregroundStyle(termsAgreed ? Color.blue : Color.gray) // FIXME: - 컬러 수정
                                    .frame(width: 24, height: 24)
                                Spacer()
                                if termsAgreed {
                                    Image(.checkBox)
                                } else {
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1) // FIXME: - 테두리 색 수정
                                        .fill(Color.white) // FIXME: - 컬러 수정
                                        .frame(width: 26, height: 26) // FIXME: - 이미지로 수정
                                }
                            }
                        }
                        Button {
                            self.showPrivacyView = true
                        } label: {
                            HStack(spacing: .zero) {
                                Text("[필수] 개인정보 처리방침에 동의합니다.")
                                    .font(Font.system(size: 16, weight: .medium)) // FIXME: - 폰트 수정
                                    .foregroundStyle(privacyAgreed ? Color.blue : Color.gray) // FIXME: - 컬러 수정
                                Image(.iconChevronRight)
                                    .foregroundStyle(privacyAgreed ? Color.blue : Color.gray) // FIXME: - 컬러 수정
                                    .frame(width: 24, height: 24)
                                Spacer()
                                
                                if privacyAgreed {
                                    Image(.checkBox)
                                } else {
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 1) // FIXME: - 테두리 색 수정
                                        .fill(Color.white) // FIXME: - 컬러 수정
                                        .frame(width: 26, height: 26) // FIXME: - 이미지로 수정
                                }
                            }
                        }
                    }
                    .padding(16)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 106)
        }
    }
}

#Preview {
    NavigationStack {
        UserInfoInputView(uuid: "", email: "")
            .environmentObject(NavigationRouter())
    }
}
