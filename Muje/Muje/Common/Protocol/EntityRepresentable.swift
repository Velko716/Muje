//
//  EntityRepresentable.swift
//  Muje
//
//  Created by 김진혁 on 8/1/25.
//

import Foundation

protocol EntityRepresentable {
    var entityName: CollectionType { get }
    var documentID: String { get }
    var asDictionary: [String: Any]? { get }
}
