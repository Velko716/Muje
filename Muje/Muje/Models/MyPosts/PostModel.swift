//
//  PostModel.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct PostModel: Hashable {
    var title: String
    var content: String
    var image: Data?
    var startDate: Date
    var endDate: Date
    var interviewStartDate: Date?
    var interviewEndDate: Date?
    var hasInterview: Bool
}
