//
//  Cell.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI

struct Cell: View {
    var calendarDay: CalendarDay
    
    @Bindable var calendarViewModel: CalendarViewModel
    var startDate: Date
    var endDate: Date
    @State var isSelectedAble: Bool = false
    @State var isSelected: Bool = true
    
    var body: some View {
        ZStack {
            if isSelectedAble {
                Circle()
                    .fill(Color.yellow.opacity(0.6))
                    .frame(width: 26, height: 27)
                    .transition(.scale.combined(with: .opacity))
            }
            
            Text("\(calendarDay.day)")
                .font(.caption)
                .foregroundStyle(textColor)
                .animation(.easeInOut(duration: 0.2), value: calendarViewModel.selectedDate)
        }
        .frame(height: 30)
        .task {
            selectSlot(date: calendarDay.date, startDate: startDate, endDate: endDate)
        }
        .onChange(of: endDate) {
            selectSlot(date: calendarDay.date, startDate: startDate, endDate: endDate)
        }
    }
    
    private var textColor: Color {
        if calendarDay.isCurrentMonth {
            if calendarDay.isToday {
                return Color.blue
            } else {
                return Color.black
            }
        } else {
            return Color.gray.opacity(0.4)
        }
    }
    
    func selectSlot(date: Date, startDate: Date, endDate: Date) {
        self.isSelectedAble = (startDate < date && date < endDate)
    }
}
