//
//  Applications.swift
//  Muje
//
//  Created by 김진혁 on 8/4/25.
//

import Foundation
import FirebaseFirestore

struct Application: Codable {
    let applicationId: UUID
    let applicantUserId: String
    let postId: String
    var status: String
    var isPassed: Bool?
    var interviewSlotId: String?
    var interviewReservationStatus: String?
    let applicantName: String
    var applicantBirthYear: Int?
    var applicantGender: String?
    var applicantDepartment: String?
    var applicantStudentId: String?
    var applicantPhone: String?
    let postTitle: String
    let postOrganization: String
    let postAuthorUserId: String

    @ServerTimestamp var appliedAt: Timestamp? = nil
    @ServerTimestamp var updatedAt: Timestamp? = nil
    
    init(
        applicationId: UUID,
        applicantUserId: String,
        postId: String,
        status: ApplicationStatus.RawValue,
        isPassed: Bool? = nil,
        interviewSlotId: String? = nil,
        interviewReservationStatus: String? = nil,
        applicantName: String,
        applicantBirthYear: Int? = nil,
        applicantGender: String? = nil,
        applicantDepartment: String? = nil,
        applicantStudentId: String? = nil,
        applicantPhone: String? = nil,
        postTitle: String,
        postOrganization: String,
        postAuthorUserId: String,
        appliedAt: Timestamp? = nil,
        updatedAt: Timestamp? = nil
    ) {
        self.applicationId = applicationId
        self.applicantUserId = applicantUserId
        self.postId = postId
        self.status = status
        self.isPassed = isPassed
        self.interviewSlotId = interviewSlotId
        self.interviewReservationStatus = interviewReservationStatus
        self.applicantName = applicantName
        self.applicantBirthYear = applicantBirthYear
        self.applicantGender = applicantGender
        self.applicantDepartment = applicantDepartment
        self.applicantStudentId = applicantStudentId
        self.applicantPhone = applicantPhone
        self.postTitle = postTitle
        self.postOrganization = postOrganization
        self.postAuthorUserId = postAuthorUserId
        self.appliedAt = appliedAt
        self.updatedAt = updatedAt
    }
    
    
    enum CodingKeys: String, CodingKey {
        case applicationId = "application_id"
        case applicantUserId = "applicant_user_id"
        case postId = "post_id"
        case status
        case isPassed = "is_passed"
        case interviewSlotId = "interview_slot_id"
        case interviewReservationStatus = "interview_reservation_status"
        case applicantName = "applicant_name"
        case applicantBirthYear = "applicant_birth_year"
        case applicantGender = "applicant_gender"
        case applicantDepartment = "applicant_department"
        case applicantStudentId = "applicant_student_id"
        case applicantPhone = "applicant_phone"
        case postTitle = "post_title"
        case postOrganization = "post_organization"
        case postAuthorUserId = "post_author_user_id"
        case appliedAt = "applied_at"
        case updatedAt = "updated_at"
    }
}

extension Application: EntityRepresentable {
    var entityName: CollectionType { .applications }

    var documentID: String { applicationId.uuidString }

    var asDictionary: [String: Any]? {
        var dict: [String: Any] = [
            "application_id": applicationId.uuidString,
            "applicant_user_id": applicantUserId,
            "post_id": postId,
            "status": status,
            "applicant_name": applicantName,
            "post_title": postTitle,
            "post_organization": postOrganization,
            "post_author_user_id": postAuthorUserId,
            //"applied_at": appliedAt ?? FieldValue.serverTimestamp(),
            //"updated_at": updatedAt ?? FieldValue.serverTimestamp()
        ]

        // Optional 값들은 존재할 경우에만 추가
        if let isPassed = isPassed {
            dict["is_passed"] = isPassed
        }
        if let interviewSlotId = interviewSlotId {
            dict["interview_slot_id"] = interviewSlotId
        }
        if let interviewReservationStatus = interviewReservationStatus {
            dict["interview_reservation_status"] = interviewReservationStatus
        }
        if let applicantBirthYear = applicantBirthYear {
            dict["applicant_birth_year"] = applicantBirthYear
        }
        if let applicantGender = applicantGender {
            dict["applicant_gender"] = applicantGender
        }
        if let applicantDepartment = applicantDepartment {
            dict["applicant_department"] = applicantDepartment
        }
        if let applicantStudentId = applicantStudentId {
            dict["applicant_student_id"] = applicantStudentId
        }
        if let applicantPhone = applicantPhone {
            dict["applicant_phone"] = applicantPhone
        }

        return dict
    }
}
