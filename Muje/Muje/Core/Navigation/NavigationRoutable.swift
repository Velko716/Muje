//
//  NavigationRoutable.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation

protocol NavigationRoutable {

    var destination: [NavigationDestination] { get set }
    
    func push(to view: NavigationDestination)
    func pop()
    func popToRootView()
}
