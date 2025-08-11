//
//  CustomNavigationBar.swift
//  Muje
//
//  Created by 조재훈 on 8/8/25.
//

import SwiftUI

struct CustomNavigationBar: View {
  let title: String
  let onBackTap: () -> Void
  
  var body: some View {
    HStack(alignment: .center) {
      Button {
        onBackTap()
      } label: {
        Image(systemName: "chevron.left")
      }
      
      Spacer()
      
      Text(title)
        .font(.system(size: 18))
      
      Spacer()
      
      Color.clear
        .frame(width: 14)
    }
    .padding(.horizontal, 22)
    .frame(height: 40)
    
    Rectangle()
      .fill(Color.gray.opacity(0.3))
      .frame(height: 0.5)
  }
}

#Preview {
  CustomNavigationBar(title: "지원서 작성", onBackTap: {})
}
