//
//  ApplicantList.swift
//  Muje
//
//  Created by 조재훈 on 8/14/25.
//

import SwiftUI

struct ApplicantList: View {
  
  let application: Application
  let onTap: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      nameSection
      departmentSection
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(
      Color.gray.opacity(0.2)
    )
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.clear, lineWidth: 2)
    )
    .contentShape(Rectangle())
    .onTapGesture {
      onTap()
    }
  }
  
  private var nameSection: some View {
    HStack {
      Text(application.applicantName)
        .font(.headline)
        .fontWeight(.medium)
      
      if let _ = application.applicantGender,
         let _ = application.applicantBirthYear {
        Text("\(application.genderDisplay) \(application.ageString)")
          .font(.subheadline)
      }
      Spacer()
    }
  }
  
  private var departmentSection: some View {
    HStack {
      if let department = application.applicantDepartment {
        Text("\(department)")
          .font(.subheadline)
      }
      Spacer()
    }
  }
}

#Preview {
  ApplicantList(
    application: Application(
      applicationId: UUID(),
      applicantUserId: "dddd",
      postId: "dddd",
      status: ApplicationStatus.submitted.rawValue,
      applicantName: "박기연",
      postTitle: "ㅇㅇㅇㅇㅇㅇㅇ",
      postOrganization: "MAD",
      postAuthorUserId: "ddddd"
    ), onTap: {}
  )
}
