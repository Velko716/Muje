//
//  TimeModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import Foundation

//지원자 기준
struct TimeModel: Identifiable, Equatable {
    let id: UUID = .init()
    var startTime: Date
    var endTime: Date
    var isStartShown: Bool
    var isEndShown: Bool
    var timeLists: [Date]
}
