//
//  MaxLengthModifier.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

struct MaxLengthModifier: ViewModifier {
    @Binding var text: String
    let maxLength: Int
    
    func body(content: Content) -> some View {
        content
            .onChange(of: text) { old, new in
                if new.count > maxLength {
                    text = old
                }
            }
    }
}
