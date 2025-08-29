//
//  NotificationView.swift
//  Muje
//
//  Created by 김서현 on 8/12/25.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var router: NavigationRouter
//    @State var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "", onBackTap: {router.pop()})
            Text("알림 화면 임시 뷰 입니다.")
            Spacer()
        }
    }
}

#Preview {
    NotificationView()
}

