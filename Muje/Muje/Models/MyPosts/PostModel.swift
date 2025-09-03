//
//  PostModel.swift
//  Muje
//
//  Created by Air on 8/23/25.
//

import SwiftUI

struct PostModel: Hashable {
    let id: UUID = .init() //포스트아이디
    var authorUserId: String //공고 작성자의 userId 참조
    var title: String
    var organization: String
    var content: String
    var recruitmentStart: Date
    var recruitmentEnd: Date
    var hasInterview: Bool
    var interivewLocation: String
    var status: String
    var requiresName: Bool
    var requiresStudentId: Bool
    var requiresDepartment: Bool
    var requiresGender: Bool
    var requiresAge: Bool
    var requiresPhone: Bool
    var authorName: String //작성자 이름(users DTO에서 name)
    var authorOrganization: String //organization 필드 값 복사
}
