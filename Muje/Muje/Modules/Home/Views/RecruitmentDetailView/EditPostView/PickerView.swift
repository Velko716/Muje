//
//  PickerView.swift
//  tempDos
//
//  Created by Air on 8/11/25.
//

import SwiftUI

struct PickerView: View {
    let title: String
    let content: String
    let function: () -> Void
    
    @State var isSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            
            Button(action: {
                function()
            }, label: {
                HStack(spacing: 6) {
                    Text(content)
                        .foregroundStyle(isSelected ? Color.black : Color.gray)
                    Spacer()
                    Image(systemName: "calendar")
                }
                .foregroundStyle(Color.gray)
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                )
                .onChange(of: content, {
                    isSelected = true
                })
            })
        }
    }
}
