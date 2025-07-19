//
//  NavigationRoutingView.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI

struct NavigationRoutingView: View {
    
    // @EnvironmentObject var container: DIContainer
    @State var destination: NavigationDestination
    
    var body: some View {
        Group {
            switch destination {
            case .contentView: // 임시
                RootView() // 임시
            }
        }
        // 각 하위 뷰에도 DIContainer를 공유해줌
        // .environmentObject(container)
    }
}
