//
//  InboxViewModel.swift
//  Muje
//
//  Created by 김진혁 on 7/20/25.
//

import Foundation

@Observable
final class InboxViewModel {
    
    
    
    func send(text: String) -> String {
        let msg = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !msg.isEmpty else { return "" }
        return ""
    }
}
