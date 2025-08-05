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
        Text("HomeView")
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
