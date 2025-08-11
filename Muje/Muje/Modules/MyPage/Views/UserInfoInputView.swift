//
//  UserInfoInputView.swift
//  Muje
//
//  Created by 김진혁 on 8/7/25.
//

import SwiftUI

struct UserInfoInputView: View {
    
    @EnvironmentObject private var router: NavigationRouter
//    @Bindable var emailVerificationVM: EmailVerificationViewModel
//    @Bindable var userInfoVM: UserInfoInputViewModel
    
    let uuid: String
    let email: String
    
    @State private var name: String = ""
    @State private var birthYear: String = "" // FIXME: - DTO는 Int
    @State private var gender: String = ""
    @State private var department: String = ""
    @State private var studentId: String = ""
    
    
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
            TextField("이름을 입력해주세요.", text: $name)
            
            Text("출생년도")
            TextField("출생년도를 입력해주세요.", text: $birthYear)
            
            HStack(spacing: 8) {
                Button {
                    self.gender = Gender.male.rawValue
                } label: {
                    Text("남")
                }
                
                Button {
                    self.gender = Gender.female.rawValue
                } label: {
                    Text("여")
                }
            }
            
            Text("학과")
            TextField("학과를 입력해주세요.", text: $department)
            
            Text("학번")
            TextField("학번을 입력해주세요.", text: $studentId)
        }
    }
    
    // MARK: - 바텀 다음 버튼 뷰
    private var bottomNextButtonView: some View {
        VStack {
            Button {
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
    UserInfoInputView(uuid: "", email: "")
        .environmentObject(NavigationRouter())
}
