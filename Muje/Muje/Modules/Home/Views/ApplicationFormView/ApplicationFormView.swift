//
//  ApplicationFormView.swift
//  Muje
//
//  Created by 조재훈 on 8/8/25.
//

import SwiftUI

struct ApplicationFormView: View {
  
  @EnvironmentObject var router: NavigationRouter
  
  @State var viewModel = ApplicationFormViewModel()
  
  @State var questionAnswer: [String: String] = [:]
  @State private var isLoading: Bool =  true
  @State private var showExitsheet: Bool = false
  
  let postId: String
  let requirementFlags: RequirementFlags
  let postBasicInfo: PostBasicInfo
  
  var body: some View {
    VStack(spacing: 0) {
      CustomNavigationBar(
        title: "지원서 작성") {
          showExitsheet = true
        }
      
      ScrollView {
        infoSection
        customQuestionSection
      }
      //.contentMargins(.vertical, 20)
      .navigationBarBackButtonHidden()
      //.ignoresSafeArea(.all, edges: .top)
      .sheet(isPresented: $showExitsheet) {
        ExitSheetView(
          exitAction: {
            showExitsheet = false
            router.pop()
          },
          keepAction: {
            showExitsheet = false
          }
        )
        .presentationDetents([.fraction(0.45)])
        .presentationCornerRadius(20)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      }
    }
    .task {
      await viewModel.loadCustomQuestion(for: postId)
    }
    bottomButtonSection
  }
}

//#Preview {
//  ApplicationFormView(postId: "")
//}
