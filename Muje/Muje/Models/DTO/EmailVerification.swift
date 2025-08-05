//
//  EmailVerifications.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation
import FirebaseFirestore

struct Verification: Codable {
    let verificationId: UUID
    let email: String
    let verificationCode: String
    let expiresAt: Timestamp
    var verified: Bool
    var attemptCount: Int
    @ServerTimestamp var createdAt: Timestamp?

    init(
        verificationId: UUID,
        email: String,
        verificationCode: String,
        expiresAt: Timestamp,
        verified: Bool = false,
        attemptCount: Int = 0,
        createdAt: Timestamp? = nil
    ) {
        self.verificationId = verificationId
        self.email = email
        self.verificationCode = verificationCode
        self.expiresAt = expiresAt
        self.verified = verified
        self.attemptCount = attemptCount
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case verificationId = "verification_id"
        case email
        case verificationCode = "verification_code"
        case expiresAt = "expires_at"
        case verified
        case attemptCount = "attempt_count"
        case createdAt = "created_at"
    }
}

extension Verification: EntityRepresentable {
    var entityName: CollectionType { .emailVerifications }

    var documentID: String { verificationId.uuidString }

    var asDictionary: [String: Any]? {
        [
            "verification_id": verificationId.uuidString,
            "email": email,
            "verification_code": verificationCode,
            "expires_at": expiresAt,
            "verified": verified,
            "attempt_count": attemptCount,
            // "created_at": createdAt ?? FieldValue.serverTimestamp()
        ]
    }
}
