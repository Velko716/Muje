//
//  SwiftUIView.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import SwiftUI

struct EmailVerificationView : View {
    @Bindable var emailVM: EmailVerificationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            TitleView
            Spacer().frame(height: 20)
            InputEmailTextFieldView
            Spacer()
            bottomButtonView
            Spacer()
        }
        .paddingH16()
    }
    
    
    // MARK: - 이메일 인증 타이틀 뷰
    private var TitleView: some View {
        VStack(alignment: .leading) {
            Text("학교 인증을 위해서\n대학교 이메일을 입력해주세요.(1/3)")
                .font(.largeTitle)
                .bold()
        }
    }
    
    // MARK: - 이메일 입력 텍스트 필드 뷰
    private var InputEmailTextFieldView: some View {
        VStack(alignment: .leading) {
            Text("학교 이메일")
                .font(.caption)
                .bold()
            
            HStack(spacing: .zero) {
                TextField("이메일을 입력해주세요.", text: $emailVM.emailText)
                Text("@jbnu.ac.kr")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
        }
    }
    
    // MARK: - 바텀 아래 인증 요청 뷰
    private var bottomButtonView: some View {
        VStack {
            Button {
                emailVM.sendVerificationEmail()
            } label: {
                Text("인증 요청")
            }
        }
    }
    
    
}

#Preview {
    EmailVerificationView(emailVM: EmailVerificationViewModel())
}
