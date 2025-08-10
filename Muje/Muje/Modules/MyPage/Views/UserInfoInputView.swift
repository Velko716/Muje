//
//  UserInfoInputView.swift
//  Muje
//
//  Created by 김진혁 on 8/7/25.
//

import SwiftUI

struct UserInfoInputView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    @Bindable var emailVerificationVM: EmailVerificationViewModel
    @Bindable var userInfoVM: UserInfoInputViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            topTitleView
            Spacer().frame(height: 80)
            middleInfoInputView
            Spacer().frame(height: 80)
            bottomNextButtonView
        } //: VSTACK
        .paddingH16()
    }
    
    // MARK: - 상단 타이틀 뷰
    private var topTitleView: some View {
        VStack(alignment: .leading) {
            Text("인적사항을 입력하세요.(2/3)")
        }
    }
    
    // MARK: - 중간 유저 정보 입력 뷰
    private var middleInfoInputView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("이름")
            TextField("이름을 입력해주세요.", text: $userInfoVM.name)
            
            Text("출생년도")
            TextField("출생년도를 입력해주세요.", text: $userInfoVM.birthYear)
            
            HStack(spacing: 8) {
                Button {
                    userInfoVM.gender = Gender.male.rawValue
                } label: {
                    Text("남")
                }
                
                Button {
                    userInfoVM.gender = Gender.female.rawValue
                } label: {
                    Text("여")
                }
            }
            
            Text("학과")
            TextField("학과를 입력해주세요.", text: $userInfoVM.department)
            
            Text("학번")
            TextField("학번을 입력해주세요.", text: $userInfoVM.studentId)
        }
    }
    
    // MARK: - 바텀 다음 버튼 뷰
    private var bottomNextButtonView: some View {
        VStack {
            Button {
                router.push(to: .phoneVerificationView)
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
    UserInfoInputView(
        emailVerificationVM: EmailVerificationViewModel(),
        userInfoVM: UserInfoInputViewModel(
            name: "",
            birthYear: "",
            gender: "",
            department: "",
            studentId: ""
        )
    )
        .environmentObject(NavigationRouter())
}
