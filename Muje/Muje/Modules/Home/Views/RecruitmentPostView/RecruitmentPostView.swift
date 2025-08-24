//
//  RecruitmentPostView.swift
//  Muje
//
//  Created by 김서현 on 8/21/25.
//

import SwiftUI

struct RecruitmentPostView: View {
    @EnvironmentObject var router: NavigationRouter
    @State var typingText = ""
    @State private var viewModel = RecruitmentPostViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                RecruitmentBasicInfoView(viewModel: viewModel)
                
                RecruitmentCustomQuestionView(viewModel: viewModel)
                
            } //: VSTACK
            .padding(.horizontal, 16)
        } //: ScrollView
        .safeAreaInset(edge: .top) {
            VStack {
                CustomNavigationBar(title: "모임 올리기") {
                    //✅ FIXME: 연결 시 필수 확인!!! 뒤로 가기로 액션 변경
                    router.pop()
                }
            }
            //네비게이션 바 배경이 투명 색이라 스크롤하면 뒤에 내용이 비쳐서 하얀색으로 배경색 설정 해두었습니다.
            .background(Color.white)
        }
        
        .safeAreaInset(edge: .bottom) {
            HStack {
                // TODO: 컴포넌트로 만든거 끌어와서 사용하기
                Button {
                    //action
                } label: {
                    Text("취소")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.2))
                        )
                    
                }
                
                Spacer()
                
                Button {
                    print("버튼 활성화 상태 : \(viewModel.canSubmit)")
                } label : {
                    Text("모집글 올리기")
                        .foregroundStyle(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.postButtonColor)
                        )
                    
                }
                
            } //: HSTACK
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity)
            .background(
                Rectangle()
                    .fill(Color.white)
                    .shadow(radius: 3)
                    .ignoresSafeArea(edges: .bottom)
            )
            
            
        }
        
        
    }
}

#Preview {
    RecruitmentPostView()
}
