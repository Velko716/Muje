//
//  NavigationRouter.swift
//  Muje
//
//  Created by 김진혁 on 7/19/25.
//

import Foundation

@Observable
class NavigationRouter: NavigationRoutable {
    
    var destination: [NavigationDestination] = []

    func push(to view: NavigationDestination) { destination.append(view) }
    func pop() { _ = destination.popLast() }
    func popToRootView() {  destination.removeAll() }
}
