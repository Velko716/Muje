//
//  Post.swift
//  Muje
//
//  Created by 김진혁 on 8/4/25.
//

import Foundation
import FirebaseFirestore

struct Post: Codable, Hashable {
    let postId: UUID
    let authorUserId: String
    let title: String
    let organization: String
    let content: String
    let recruitmentStart: Timestamp
    let recruitmentEnd: Timestamp
    var hasInterview: Bool
    var status: String
    var requiresName: Bool
    var requiresStudentId: Bool
    var requiresDepartment: Bool
    var requiresGender: Bool
    var requiresAge: Bool
    var requiresPhone: Bool
    let authorName: String
    let authorOrganization: String

    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
    
    init(
        postId: UUID,
        authorUserId: String,
        title: String,
        organization: String,
        content: String,
        recruitmentStart: Timestamp,
        recruitmentEnd: Timestamp,
        hasInterview: Bool = false,
        status: PostStatus.RawValue,
        requiresName: Bool = true,
        requiresStudentId: Bool = false,
        requiresDepartment: Bool = false,
        requiresGender: Bool = false,
        requiresAge: Bool = false,
        requiresPhone: Bool = false,
        authorName: String,
        authorOrganization: String,
        createdAt: Timestamp? = nil,
        updatedAt: Timestamp? = nil
    ) {
        self.postId = postId
        self.authorUserId = authorUserId
        self.title = title
        self.organization = organization
        self.content = content
        self.recruitmentStart = recruitmentStart
        self.recruitmentEnd = recruitmentEnd
        self.hasInterview = hasInterview
        self.status = status
        self.requiresName = requiresName
        self.requiresStudentId = requiresStudentId
        self.requiresDepartment = requiresDepartment
        self.requiresGender = requiresGender
        self.requiresAge = requiresAge
        self.requiresPhone = requiresPhone
        self.authorName = authorName
        self.authorOrganization = authorOrganization
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case authorUserId = "author_user_id"
        case title
        case organization
        case content
        case recruitmentStart = "recruitment_start"
        case recruitmentEnd = "recruitment_end"
        case hasInterview = "has_interview"
        case status
        case requiresName = "requires_name"
        case requiresStudentId = "requires_student_id"
        case requiresDepartment = "requires_department"
        case requiresGender = "requires_gender"
        case requiresAge = "requires_age"
        case requiresPhone = "requires_phone"
        case authorName = "author_name"
        case authorOrganization = "author_organization"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension Post: EntityRepresentable {
    var entityName: CollectionType { .posts }

    var documentID: String { postId.uuidString }

    var asDictionary: [String: Any]? {
        [
            "post_id" : postId.uuidString,
            "author_user_id": authorUserId,
            "title": title,
            "organization": organization,
            "content": content,
            "recruitment_start": recruitmentStart,
            "recruitment_end": recruitmentEnd,
            "has_interview": hasInterview,
            "status": status,
            "requires_name": requiresName,
            "requires_student_id": requiresStudentId,
            "requires_department": requiresDepartment,
            "requires_gender": requiresGender,
            "requires_age": requiresAge,
            "requires_phone": requiresPhone,
            "author_name": authorName,
            "author_organization": authorOrganization,
            //"created_at": createdAt ?? FieldValue.serverTimestamp(),
            //"updated_at": updatedAt ?? FieldValue.serverTimestamp()
        ]
    }
}
