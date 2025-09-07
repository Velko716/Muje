//
//  SelectView.swift
//  Muje
//
//  Created by Air on 9/3/25.
//

import SwiftUI

struct SelectView: View {
    @State var calendarViewModel: CalendarViewModel = .init()
    @Bindable var selectViewModel: SelectViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 20) {
                navigationBar
                
                headerController
                
                calendarView
                
                slotListsView
            }
            .padding(.horizontal, 16)
            
            Button(action: {
                print("면접 일정")
                selectViewModel.isSelected = true
                if let idx = selectViewModel.currentIndex {
                    selectViewModel.lists[idx].currentReservations += 1
                }
            }, label: {
                ActionButton(title: selectViewModel.str, condition: selectViewModel.currentIndex == nil)
                    .padding(.horizontal, 16)
            })
            .disabled(selectViewModel.currentIndex == nil)
        }
        .onChange(of: selectViewModel.currentDate) {
            selectViewModel.buttonString()
        }
        .onChange(of: selectViewModel.currentIndex) {
            selectViewModel.buttonString()
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Button(action: {
                selectViewModel.isSetting = false
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color.black)
            })
            
            Spacer()
            
            Text("면접 일정")
            
            Spacer()
            
            Button(action: {
                selectViewModel.isSetting = false
            }, label: {
                Text("완료")
                    .foregroundStyle(selectViewModel.isSelected ? Color.black : Color.gray)
            })
            .disabled(!selectViewModel.isSelected)
        }
    }
    
    private var headerController: some View {
        HStack(spacing: 47, content: {
            Button(action: {
                calendarViewModel.changeMonth(by: -1)
            }, label: {
                Image(systemName: "chevron.left")
            })
            
            Text(calendarViewModel.currentMonth, formatter: calendarViewModel.calendarHeaderDateFormatter)
                .font(.title3)
                .foregroundStyle(Color.black)
            
            Button(action: {
                calendarViewModel.changeMonth(by: 1)
            }, label: {
                Image(systemName: "chevron.right")
            })
        })
    }
    
    private var calendarView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5, content: {
            ForEach(calendarViewModel.localizedWeekdaysSymbols.indices, id: \.self) { index in
                Text(calendarViewModel.localizedWeekdaysSymbols[index])
                    .foregroundStyle(Color.gray)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
            }
            .padding(.bottom, 30)
            
            ForEach(calendarViewModel.daysForCurrentGrid(), id: \.id) { calendarDay in
                Button(action: {
                    selectViewModel.currentDate = calendarDay.date
                }, label: {
                    if selectViewModel.lists.contains(where: { $0.interviewDate.dateValue().dateString == calendarDay.date.dateString }) {
                        Cell(calendarDay: calendarDay, calendarViewModel: calendarViewModel, startDate: .now, endDate: .now, condition: true)
                    } else {
                        Cell(calendarDay: calendarDay, calendarViewModel: calendarViewModel, startDate: .now, endDate: .now)
                    }
                })
                
            }
        })
        .frame(height: 250, alignment: .top)
    }
    
    private var slotListsView: some View {
        List {
            ForEach(selectViewModel.lists.indices, id: \.self) { idx in
                if checkDate(idx: idx) {
                    Button(action: {
                        selectViewModel.currentIndex = idx
                    }, label: {
                        HStack {
                            Text(selectViewModel.lists[idx].interviewDate.dateValue().dateString)
                            Text(selectViewModel.lists[idx].interviewTime)
                        }
                        .foregroundStyle(selectViewModel.checkMax(slot: selectViewModel.lists[idx]) ? Color.gray : Color.black)
                        
                    })
                    .border(selectViewModel.currentIndex == idx ? Color.blue : (Color.clear))
                    .disabled(selectViewModel.checkMax(slot: selectViewModel.lists[idx]))
                }
            }
        }
    }
    
    func checkDate(idx: Int) -> Bool {
        return selectViewModel.currentDate?.dateString == selectViewModel.lists[idx].interviewDate.dateValue().dateString
    }
}

#Preview {
    SelectView(selectViewModel: .init())
}
