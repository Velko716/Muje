import SwiftUI

struct CalendarCell: View {
  var calendarDay: CalendarDay
  
  @Bindable var calendarViewModel: CalendarViewModel
  @Bindable var interviewSlotViewModel: InterviewSlotViewModel
  var startDate: Date
  var endDate: Date
  @State var isSelectedAble: Bool = false
  @State var isSelected: Bool = true
  @State private var wasSelected = false
  var condition: Bool?
  
  private var hasInterviewData: Bool {
    return interviewSlotViewModel.interviewSlotLists.contains { interviewSlot in
      return interviewSlot.interviewDate.dateValue().dateOnly == calendarDay.date.dateOnly
    }
  }
  
  private var isLastSelectedDate: Bool {
    guard let lastSelected = interviewSlotViewModel.lastSelectedDate else { return false }
    return lastSelected == calendarDay.date.stripTime()
  }
  
  private var isDateSelected: Bool {
    return interviewSlotViewModel.selectedDays.contains(calendarDay.date.stripTime())
  }
  
  var body: some View {
    ZStack {
      if calendarViewModel.selectedDate.dateOnly == calendarDay.date.dateOnly {
        Circle()
          .stroke(Color.pointSkyBlue, lineWidth: 1)
          .frame(width: 30, height: 30)
          .transition(.scale.combined(with: .opacity))
      } else if isLastSelectedDate {
        Circle()
          .fill(Color.pointSkyBlue)
          .frame(width: 30, height: 30)
          .transition(.scale.combined(with: .opacity))
      } else if isDateSelected {
        Circle()
          .fill(Color.pointSkyBlueTinted)
          .frame(width: 30, height: 30)
          .transition(.scale.combined(with: .opacity))
      }
      
      Text("\(calendarDay.day)")
        .caption14Medium()
        .foregroundStyle(textColor)
        .animation(.easeInOut(duration: 0.2), value: calendarViewModel.selectedDate)
        .overlay {
          if calendarDay.isToday && calendarViewModel.selectedDate.dateOnly != calendarDay.date.dateOnly {
            Circle()
              .stroke(Color.pointSkyBlue, lineWidth: 1)
              .frame(width: 30, height: 30)
          }
        }
    }
    .frame(width: 30, height: 30)
    .task {
      selectSlot()
    }
    .onChange(of: endDate) {
      selectSlot()
    }
  }
  
  private var textColor: Color {
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: calendarDay.date)
    
    if interviewSlotViewModel.checkSlot(date: calendarDay.date, startDate: startDate, endDate: endDate) {
      return .gray300
    }
    
    if calendarDay.isCurrentMonth {
      if calendarDay.isToday {
        return .pointSkyBlue
      }
      else if calendarViewModel.selectedDate.dateOnly == calendarDay.date.dateOnly {
        return .white
      } else if hasInterviewData {
        return .white
      } else if isLastSelectedDate {
        return .white
      } else if isDateSelected {
        return .gray700
      } else if calendarDay.isToday {
        return .pointSkyBlue
      } else if wasSelected {
        return .black
      } else if weekday == 1 {
        return .statusTextRed
      } else if weekday == 7 {
        return .statusTextBlue
      } else {
        return .gray700
      }
    } else {
      return .gray300
    }
  }
  
  func selectSlot() {
    let newSelected = (startDate <= calendarDay.date && calendarDay.date < endDate)
    if isSelectedAble && !newSelected {
      // 선택되어 있다가 해제된 경우
      wasSelected = true
    }
    isSelectedAble = newSelected
  }
}

extension Date {
  var dateOnly: Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: self)
    return calendar.date(from: components) ?? self
  }
}
