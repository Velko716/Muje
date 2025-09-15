//
//  TimeModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import Foundation

//지원자 기준
struct TimeModels: Identifiable, Equatable {
    let id: UUID
    var startTime: Date
    var endTime: Date
    var isStartShown: Bool
    var isEndShown: Bool
    var timeLists: [Date]
}
