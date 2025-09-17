//
//  ListCardView.swift
//  Muje
//
//  Created by Air on 9/17/25.
//

import SwiftUI
import FirebaseFirestore

struct ListCardView: View {
    @State var lists: [Timestamp] = []
    @Bindable var interviewSlotViewModel: InterviewSlotViewModel
    @Binding var slot: TimeModel
    
    var body: some View {
        HStack(spacing: 24) {
            Button(action: {
                interviewSlotViewModel.removeItem(withId: slot.timeId)
            }, label: {
                Image(systemName: "xmark")
                
            })
            Spacer()
            Text(slot.startTime.dateValue().shortDateString)
            Spacer()
            Button(action: {
                slot.isStartShown.toggle()
            }, label: {
                Text(slot.startTime.dateValue().hourMinute24)
                    .startPicker(isShown: slot.isStartShown, date: $slot.startTime)
            })
            Button(action: {
                slot.isEndShown.toggle()
            }, label: {
                Text(slot.endTime.dateValue().hourMinute24)
                    .endPicker(isShown: slot.isEndShown, endTime: $slot.endTime, lists: $lists)
            })
        }
        .task {
            lists = interviewSlotViewModel.updateSlotTime(slot: $slot)
        }
        .onChange(of: slot.startTime) {
            let end: Date = $slot.wrappedValue.startTime.dateValue().addingTimeInterval(TimeInterval(60 * interviewSlotViewModel.timeInterval))
            slot.endTime = Timestamp(date: end)
            lists = interviewSlotViewModel.updateSlotTime(slot: $slot)
        }
        .padding()
    }
}

#Preview {
    ListCardView(interviewSlotViewModel: .init(), slot: .constant(.init(timeId: .init(), postId: "Ss", startTime: .init(), endTime: .init(), isStartShown: false, isEndShown: false)))
}
