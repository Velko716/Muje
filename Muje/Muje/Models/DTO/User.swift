//
//  User.swift
//  Muje
//
//  Created by 김진혁 on 8/1/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


struct Block: Codable {
    let blockedUserId: String
    @ServerTimestamp var createdAt: Timestamp?
    
    init(
        blockedUserId: String,
        createdAt: Timestamp? = nil
    ) {
        self.blockedUserId = blockedUserId
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case blockedUserId = "blocked_user_id"
        case createdAt = "created_at"
    }
}


struct User: Codable {
    let userId: UUID
    let email: String
    let name: String
    let birthYear: Int
    let gender: String
    let department: String
    let studentId: String
    let phone: String
    let emailVerified: Bool
    let phoneVerified: Bool
    let termsAgreed: Bool
    let privacyAgreed: Bool
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
//    let createdAt: Date
//    let updatedAt: Date
    
    init(
        userId: UUID,
        email: String,
        name: String,
        birthYear: Int,
        gender: String,
        department: String,
        studentId: String,
        phone: String,
        emailVerified: Bool,
        phoneVerified: Bool,
        termsAgreed: Bool,
        privacyAgreed: Bool,
        createdAt: Timestamp? = nil,
        updatedAt: Timestamp? = nil
//        createdAt: Date,
//        updatedAt: Date,
    ) {
        self.userId = userId
        self.email = email
        self.name = name
        self.birthYear = birthYear
        self.gender = gender
        self.department = department
        self.studentId = studentId
        self.phone = phone
        self.emailVerified = emailVerified
        self.phoneVerified = phoneVerified
        self.termsAgreed = termsAgreed
        self.privacyAgreed = privacyAgreed
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case name
        case birthYear = "birth_year"
        case gender
        case department
        case studentId = "student_id"
        case phone
        case emailVerified = "email_verified"
        case phoneVerified = "phone_verified"
        case termsAgreed = "terms_agreed"
        case privacyAgreed = "privacy_agreed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension User: EntityRepresentable {
    var entityName: CollectionType { .user }
    var documentID: String { userId.uuidString }
   
    var asDictionary: [String: Any]? {
        [
            "user_id": userId.uuidString,
            "email": email,
            "name": name,
            "birth_year": birthYear,
            "gender": gender,
            "department": department,
            "student_id": studentId,
            "phone": phone,
            "email_verified": emailVerified,
            "phone_verified": phoneVerified,
            "terms_agreed": termsAgreed,
            "privacy_agreed": privacyAgreed
//            "created_at": createdAt ?? FieldValue.serverTimestamp(),
//            "updated_at": updatedAt ?? FieldValue.serverTimestamp(),
        ]
    }
}

extension User {
    func addBlock(_ block: Block) async throws {
        let docRef = Firestore.firestore()
            .collection("User")
            .document(self.userId.uuidString)
            .collection("blocks")
            .document(self.userId.uuidString)

        try await docRef.setData(block.asDictionary)
    }
}

extension Block {
    var asDictionary: [String: Any] {
        [
            "blocked_user_id": blockedUserId,
            "created_at": FieldValue.serverTimestamp()
        ]
    }
}

// MARK: - FieldValue.serverTimestamp()를 사용하므로, Codable형태로 인코딩이 불가함.
//extension Encodable {
//    var asDictionary: [String: Any]? {
//        guard let object = try? JSONEncoder().encode(self),
//              let dictionary = try? JSONSerialization.jsonObject(with: object, options: [])
//                as? [String: Any] else {
//            return nil
//        }
//        
//        return dictionary
//    }
//}
