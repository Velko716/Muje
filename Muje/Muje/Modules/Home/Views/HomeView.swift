//
//  HomeView.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Button {
            router.push(to: .makeRecruitmentView)
        } label: {
            Text("공고 만들기 탭으로 이동")
        }

    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
