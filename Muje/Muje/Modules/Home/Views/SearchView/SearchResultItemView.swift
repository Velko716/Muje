//
//  SearchResultItemView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct SearchResultItemView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        VStack {
            Button {
                router.pop()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24))
            }

            Text("임시 뷰 입니다.")
        }
        
    }
}

#Preview {
    SearchResultItemView()
}
