//
//  TextField+.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

extension TextField {
    func maxLength(text: Binding<String>, _ maxLength: Int) -> some View {
        return ModifiedContent(content: self, modifier: MaxLengthModifier(text: text, maxLength: maxLength))
    }
}
