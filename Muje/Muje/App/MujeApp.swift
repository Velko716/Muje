//
//  MujeApp.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import SwiftUI

@main
struct MujeApp: App {
    
    @StateObject var container: DIContainer = .init()
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environmentObject(container)
    }
}
