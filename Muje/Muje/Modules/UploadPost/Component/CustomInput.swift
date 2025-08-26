//
//  CustomInput.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct CustomInput: View {
    var title: String
    var tempTitle: String
    var textValue: Binding<String>
    var subTitle: String?
    let maxLength: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            if let sub = subTitle {
                HStack(spacing: 4) {
                    Text(title)
                    Text(sub)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
            } else {
                Text(title)
            }
            TextField(tempTitle, text: textValue, axis: .vertical)
                .maxLength(text: textValue, maxLength)
                .bold()
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .strokeBorder(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}
