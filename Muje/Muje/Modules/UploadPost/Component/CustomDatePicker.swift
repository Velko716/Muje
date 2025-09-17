//
//  CustomDatePicker.swift
//  Muje
//
//  Created by Air on 8/30/25.
//

import SwiftUI
import FirebaseFirestore

struct CustomDatePicker: UIViewRepresentable {
    @Binding var date: Timestamp
    
    var minuteInterval: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = minuteInterval
        
        datePicker.addTarget(
            context.coordinator,
            action: #selector(Coordinator.dateChanged(_:)),
            for: .valueChanged
        )
        return datePicker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.minuteInterval = minuteInterval
        uiView.setDate(date.dateValue(), animated: true)
    }

    class Coordinator: NSObject {
        var parent: CustomDatePicker

        init(_ parent: CustomDatePicker) {
            self.parent = parent
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.date = Timestamp(date: sender.date)
        }
    }
}
