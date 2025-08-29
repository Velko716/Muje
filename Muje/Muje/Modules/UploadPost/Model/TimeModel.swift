//
//  TimeModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import Foundation

//지원자 기준
struct TimeModel: Hashable {
    var startTime: Date
    var endTime: Date
    var isStartShown: Bool
    var isEndShown: Bool
    var timeLists: [Date]
    
//    init(startTime: Date, endTime: Date, isStartShown: Bool, isEndShown: Bool, timeLists: [Date]) {
//        self.startTime = startTime
//        self.endTime = endTime
//        self.isStartShown = isStartShown
//        self.isEndShown = isEndShown
//        self.timeLists = timeLists
//    }
}
