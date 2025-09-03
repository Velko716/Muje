//
//  CountButton.swift
//  Muje
//
//  Created by Air on 8/29/25.
//

import SwiftUI

struct CountButton: View {
    @Binding var value: Int
    
    var title: String
    var count: Int
    var unit: String
    var condition: Bool?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
            HStack(spacing: 32) {
                Button(action: {
                    self.value -= count
                }, label: {
                    Image(systemName: "minus")
                })
                .disabled((value - count) <= 0)
                
                Text("\(value)\(unit)")
                
                Button(action: {
                    self.value += count
                }, label: {
                    Image(systemName: "plus")
                })
                .disabled(condition ?? false)
            }
        }
    }
}

#Preview {
    CountButton(value: .constant(1), title: "qwer", count: 2, unit: "SS")
}
