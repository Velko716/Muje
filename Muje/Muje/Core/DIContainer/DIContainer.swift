//
//  DIContainer.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation


final class DIContainer: ObservableObject {
    /// 화면 전환 담당 라우터
    @Published var navigationRouter: NavigationRouter
    
    init(
        navigationRouter: NavigationRouter = .init(),
    ) {
        self.navigationRouter = navigationRouter
    }
    
}
