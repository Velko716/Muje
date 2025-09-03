//
//  CalendarViewModel.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI

@Observable
class CalendarViewModel {
    var currentMonth: Date
    var selectedDate: Date
    var calendar: Calendar
    
    var selectedDates: [Date] = []
    
    var currentMonthYear: Int {
        Calendar.current.component(.year, from: currentMonth)
    }
    
    let localizedWeekdaysSymbols: [String] = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols ?? []
    }()
    
    let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter
    }()
    
    init(currentMonth: Date = Date(), selectedDate: Date = Date(), calendar: Calendar = Calendar.current) {
        self.currentMonth = currentMonth
        self.selectedDate = selectedDate
        self.calendar = calendar
    }
    
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func daysForCurrentGrid() -> [CalendarDay] {
        let calendar = Calendar.current
        
        let firstDay = firstDayOfMonth()
        let firstWeekDay = calendar.component(.weekday, from: firstDay)
        let daysInMonth = numberOfDays(in: currentMonth)
        
        var days: [CalendarDay] = []
        
        let leadingDays = (firstWeekDay - calendar.firstWeekday + 7) % 7
        
        if leadingDays > 0, let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            let daysInPreviousMonth = numberOfDays(in: previousMonth)
            for i in 0..<leadingDays {
                let day = daysInPreviousMonth - leadingDays + 1 + i
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    days.append(CalendarDay(day: day, date: date, isCurrentMonth: false, isToday: false))
                }
            }
        }
        
        for day in 1...daysInMonth {
            var components = calendar.dateComponents([.year, .month], from: currentMonth)
            components.day = day
            components.hour = 0
            components.minute = 0
            components.second = 0
            
            if let date = calendar.date(from: components) {
                if date.dateString.contains(Date.now.dateString) {
                    days.append(CalendarDay(day: day, date: date, isCurrentMonth: true, isToday: true))
                } else {
                    days.append(CalendarDay(day: day, date: date, isCurrentMonth: true, isToday: false))
                }
            }
        }
        
        let remaining = (7 - days.count % 7) % 7
        if remaining > 0,
           let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            let  daysInNextMonth = numberOfDays(in: nextMonth)
            
            for day in 1...remaining {
                let validDay = min(day, daysInNextMonth)
                if let date = calendar.date(bySetting: .day, value: validDay, of: nextMonth) {
                    days.append(CalendarDay(day: day, date: date, isCurrentMonth: false, isToday: false))
                }
            }
        }
//        print(days)
        return days
    }
    
    func numberOfDays(in date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    private func firstWeekDayOfMonth(id date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDay = Calendar.current.date(from: components)!
        return Calendar.current.component(.weekday, from: firstDay)
    }
    
    func firstDayOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: currentMonth)
        return Calendar.current.date(from: components) ?? Date()
    }
}
