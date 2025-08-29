//
//  TestHomeView.swift
//  Muje
//
//  Created by 조재훈 on 8/8/25.
//

import SwiftUI

struct TestHomeView: View {
  @EnvironmentObject private var router: NavigationRouter
  
  @State private var testCreator = TestDataCreator()
  
  
  var body: some View {
    VStack {
      Text("파베 테스트 ㄱㄱ")
        .font(.largeTitle)
        .fontWeight(.bold)
      
      Text("데이터 저장 ㄱㄱ")
      
      createData
      
      Text("postId: \(testCreator.inputPostId) \n 이거 가지고 상세화면 이동 ㄱㄱ")
      Button {
        router.push(to: .RecruitmentDetailView(postId: testCreator.inputPostId))
      } label: {
        Text("공고 상세로 ㄱㄱ")
      }

    }
  }
}

extension TestHomeView {
  private var createData: some View {
    Button {
      Task {
        await testCreateData()
      }
    } label: {
      Text("테스트 데이터 생성")
    }
  }
  private var moveToDetail: some View {
    Button {
      //
    } label: {
      Text("가즈아")
    }

  }
  private func testCreateData() async {
    _ = await testCreator.createTestPostData()
  }
}

#Preview {
  NavigationStack {
    TestHomeView()
      .environmentObject(NavigationRouter())    
  }
}
