//
//  PhoneVerifications.swift
//  Muje
//
//  Created by 김진혁 on 8/5/25.
//

import Foundation
import FirebaseFirestore

struct PhoneVerification: Codable {
    let verificationId: UUID
    let phone: String
    let verificationCode: String
    let expiresAt: Timestamp
    var verified: Bool
    var attemptCount: Int
    @ServerTimestamp var createdAt: Timestamp?

    init(
        verificationId: UUID,
        phone: String,
        verificationCode: String,
        expiresAt: Timestamp,
        verified: Bool = false,
        attemptCount: Int = 0,
        createdAt: Timestamp? = nil
    ) {
        self.verificationId = verificationId
        self.phone = phone
        self.verificationCode = verificationCode
        self.expiresAt = expiresAt
        self.verified = verified
        self.attemptCount = attemptCount
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case verificationId = "verification_id"
        case phone
        case verificationCode = "verification_code"
        case expiresAt = "expires_at"
        case verified
        case attemptCount = "attempt_count"
        case createdAt = "created_at"
    }
}

extension PhoneVerification: EntityRepresentable {
    var entityName: CollectionType { .phoneVerifications }

    var documentID: String { verificationId.uuidString }

    var asDictionary: [String: Any]? {
        [
            "verification_id": verificationId.uuidString,
            "phone": phone,
            "verification_code": verificationCode,
            "expires_at": expiresAt,
            "verified": verified,
            "attempt_count": attemptCount,
            //"created_at": createdAt ?? FieldValue.serverTimestamp()
        ]
    }
}
