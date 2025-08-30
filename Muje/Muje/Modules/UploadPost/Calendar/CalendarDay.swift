//
//  CalendarDay.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import Foundation

struct CalendarDay: Identifiable {
    var id: UUID = .init()
    let day: Int
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
}
