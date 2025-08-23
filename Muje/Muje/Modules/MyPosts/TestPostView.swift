//
//  TestHomeView.swift
//  Muje
//
//  Created by 조재훈 on 8/8/25.
//

import SwiftUI
import FirebaseFirestore

struct TestPostView: View {
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
      
      
//      Text("공고 상세로 ㄱㄱ")
      
      Button {
        guard let post = testCreator.post else { return }
        router.push(
          to: .EditPostView(
            post: post,
            postImages: testCreator.postImage
          )
        )
      } label: {
        Text("수정뷰 ㄱㄱ")
      }
    }
  }
}




extension TestPostView {
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
    TestPostView()
      .environmentObject(NavigationRouter())
  }
}
