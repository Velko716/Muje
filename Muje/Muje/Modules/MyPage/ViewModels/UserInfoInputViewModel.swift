//
//  UserInfoInputViewModel.swift
//  Muje
//
//  Created by 김진혁 on 8/7/25.
//

import Foundation

@Observable
final class UserInfoInputViewModel {
    
    var name: String
    var birthYear: String // FIXME: - DTO는 Int
    var gender: String
    var department: String
    var studentId: String
    
    init(
        name: String,
        birthYear: String,
        gender: String,
        department: String,
        studentId: String
    ) {
        self.name = name
        self.birthYear = birthYear
        self.gender = gender
        self.department = department
        self.studentId = studentId
    }
}
