//
//  TestDataCreator.swift
//  Muje
//
//  Created by 조재훈 on 8/8/25.
//

import Foundation
import FirebaseFirestore

class TestDataCreator {
  private let firesotreManager = FirestoreManager.shared
  
  var inputPostId: String = ""
  var post: Post?
  var createdInterviewSlots: [InterviewSlot] = []
  var postImage: [PostImage] = []
  
  func createTestPostData() async -> String? {
    let testPostId = UUID()
    print("testPostId: \(testPostId)")
    
    let testPost = Post(
      postId: testPostId,
      authorUserId: "current_user_id",
      title: "파베 테스트 테스트 테스트",
      organization: "파이어베이스",
      content: "이게 되네",
      recruitmentStart: Timestamp(date: Date()),
      recruitmentEnd: Timestamp(date: Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()),
      hasInterview: true,
      status: PostStatus.recruiting.rawValue,
      requiresName: true,
      requiresStudentId: true,
      requiresDepartment: true,
      requiresGender: true,
      requiresAge: true,
      requiresPhone: true,
      authorName: "Kadan",
      authorOrganization: "파이어베이스"
    )
    
    self.post = testPost
    
    do {
      let createPost = try await firesotreManager.create(testPost)
      
//      await createTestPostImage(postId: testPostId.uuidString)
//      await createTestPostCustomQuestion(postId: testPostId.uuidString)
      await loadImage(postId: "B47D4B30-767D-4AF5-8311-09C0370A1749")
      await createTestInterviewSlots(postId: testPostId.uuidString)
      await createTestUserData(userId: testPostId.uuidString)
      await createApplicationData(postId: testPostId.uuidString)
      print("공고 정보 테스트 생성 완 : \(createPost.postId)")
      
      inputPostId = testPostId.uuidString
      
      return testPostId.uuidString
    } catch {
      return nil
    }
  }
  
  private func createTestPostImage(postId: String) async {
    let testImages = [
      PostImage(
        imageId: UUID(),
        postId: postId,
        imageUrl: "https://picsum.photos/400/300?random=11",
        imageOrder: 0,
        createdAt: Timestamp(date: Date())
      ),
      PostImage(
        imageId: UUID(),
        postId: postId,
        imageUrl: "https://picsum.photos/400/300?random=12",
        imageOrder: 1,
        createdAt: Timestamp(date: Date())
      ),
      PostImage(
        imageId: UUID(),
        postId: postId,
        imageUrl: "https://picsum.photos/400/300?random=13",
        imageOrder: 2,
        createdAt: Timestamp(date: Date())
      ),
      PostImage(
        imageId: UUID(),
        postId: postId,
        imageUrl: "https://picsum.photos/400/300?random=14",
        imageOrder: 3,
        createdAt: Timestamp(date: Date())
      )
    ]
    
    for image in testImages {
      do {
        _ = try await firesotreManager.create(image)
        print("\(postId)의 공고 이미지 테스트 생성, order : \(image.imageOrder)")
      } catch {
        print("공고 이미지 테스트 생성 실패")
      }
    }
  }
  
  // MARK: - 스토리지 경로 저장된 postImage 불러와서 테스트 해보기
  private func loadStorageTestPostImage(postId: String) async throws -> [PostImage]  {
    return try await firesotreManager.fetchWithCondition(
      from: .postImages,
      whereField: "post_id",
      equalTo: postId,
      sortedBy: { $0.imageOrder < $1.imageOrder}
    )
  }
  
  private func loadImage(postId: String) async {
    do {
      let images = try await loadStorageTestPostImage(postId: postId)
      self.postImage = images
    } catch {
      print("스토리지 불러오기 실패")
    }
  }
  
  private func createTestPostCustomQuestion(postId: String) async {
    let testQuestion = [
      CustomQuestion(
        questionId: UUID(),
        postId: postId,
        questionText: "햄버거 몇개 드시나요?",
        questionOrder: 1,
        createdAt: Timestamp(date: Date())
      ),
      CustomQuestion(
        questionId: UUID(),
        postId: postId,
        questionText: "피자는 몇개 드시나요?",
        questionOrder: 2,
        createdAt: Timestamp(date: Date())
      ),
      CustomQuestion(
        questionId: UUID(),
        postId: postId,
        questionText: "담배 피우시나요?",
        questionOrder: 3,
        createdAt: Timestamp(date: Date())
      )
    ]
    
    for question in testQuestion {
      do {
        _ = try await firesotreManager.create(question)
        print("\(postId)의 공고 테스트 질문 생성 완료: \(question.questionText)")
      } catch {
        print("공고 테스트 질문 생성 실패")
      }
    }
  }

  private func createTestInterviewSlots(postId: String) async {
    let calendar = Calendar.current
    let baseDate = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
    
    let testSlots = [
      // 8월 26일 (월요일) 면접
      InterviewSlot(
        slotId: UUID(),
        postId: postId,
        interviewDate: Timestamp(date: baseDate),
        interviewTime: "14:00",
        maxCapacity: 3,
        currentReservations: 0,
        createdAt: Timestamp(date: Date())
      ),
      InterviewSlot(
        slotId: UUID(),
        postId: postId,
        interviewDate: Timestamp(date: baseDate),
        interviewTime: "16:00",
        maxCapacity: 3,
        currentReservations: 0,
        createdAt: Timestamp(date: Date())
      ),
      // 8월 27일 (화요일) 면접
      InterviewSlot(
        slotId: UUID(),
        postId: postId,
        interviewDate: Timestamp(date: calendar.date(byAdding: .day, value: 1, to: baseDate) ?? baseDate),
        interviewTime: "15:00",
        maxCapacity: 2,
        currentReservations: 0,
        createdAt: Timestamp(date: Date())
      ),
      InterviewSlot(
        slotId: UUID(),
        postId: postId,
        interviewDate: Timestamp(date: calendar.date(byAdding: .day, value: 1, to: baseDate) ?? baseDate),
        interviewTime: "17:00",
        maxCapacity: 2,
        currentReservations: 0,
        createdAt: Timestamp(date: Date())
      )
    ]

    
    for slot in testSlots {
      do {
        _ = try await firesotreManager.create(slot)
        createdInterviewSlots.append(slot)
        print("\(postId)의 테스트 면접 슬롯 생성: \(slot.interviewTime)")
        print("\(slot.slotId.uuidString) 인터뷰 슬롯 아이디 생성 완료")
      } catch {
        print("테스트 면접 슬롯 생성 실패")
      }
    }
  }
  
  private func createTestUserData(userId: String) async {
    let userData = User(
      userId: userId,
      email: "elelel@naver.com",
      name: "박기연",
      birthYear: 1993,
      gender: "M",
      department: "기계설비",
      studentId: "201244422",
//      phone: "010-0101-1010",
      emailVerified: true,
//      phoneVerified: true,
      termsAgreed: true,
      privacyAgreed: true
    )
    
    do {
      _ = try await firesotreManager.create(userData)
      print("postId와 동일한\(userData.userId)의 테스트 유저데이터 생성 완료")
    } catch {
      print("postId와 동일한\(userData.userId)의 테스트 유저데이터 생성 실패")
    }
  }
  
  private func createApplicationData(postId: String) async {
    let applicationData = [
      Application(
        applicationId: UUID(),
        applicantUserId: "user1",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        interviewSlotId: nil,
        applicantName: "조재훈",
        applicantBirthYear: 2000,
        applicantGender: "M",
        applicantDepartment: "커뮤니케이션학과",
        applicantStudentId: "202012345",
        applicantPhone: "010-1234-5678",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user1",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        interviewSlotId: createdInterviewSlots[0].slotId.uuidString,
        applicantName: "제이콥",
        applicantBirthYear: 2000,
        applicantGender: "M",
        applicantDepartment: "커뮤니케이션학과",
        applicantStudentId: "202012345",
        applicantPhone: "010-1234-5678",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user1",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        interviewSlotId: nil,
        applicantName: "제이콥",
        applicantBirthYear: 2000,
        applicantGender: "M",
        applicantDepartment: "커뮤니케이션학과",
        applicantStudentId: "202012345",
        applicantPhone: "010-1234-5678",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user1",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        interviewSlotId: createdInterviewSlots[1].slotId.uuidString,
        applicantName: "제이콥",
        applicantBirthYear: 2000,
        applicantGender: "M",
        applicantDepartment: "커뮤니케이션학과",
        applicantStudentId: "202012345",
        applicantPhone: "010-1234-5678",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user1",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        interviewSlotId: createdInterviewSlots[2].slotId.uuidString,
        applicantName: "제이콥",
        applicantBirthYear: 2000,
        applicantGender: "M",
        applicantDepartment: "커뮤니케이션학과",
        applicantStudentId: "202012345",
        applicantPhone: "010-1234-5678",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user1",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        interviewSlotId: createdInterviewSlots[3].slotId.uuidString,
        applicantName: "제이콥",
        applicantBirthYear: 2000,
        applicantGender: "M",
        applicantDepartment: "커뮤니케이션학과",
        applicantStudentId: "202012345",
        applicantPhone: "010-1234-5678",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user2",
        postId: postId,
        status: ApplicationStatus.interviewWaiting.rawValue,
        interviewSlotId: createdInterviewSlots[0].slotId.uuidString,
        applicantName: "헤리",
        applicantBirthYear: 2001,
        applicantGender: "F",
        applicantDepartment: "컴퓨터공학과",
        applicantStudentId: "202112345",
        applicantPhone: "010-2345-6789",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user2",
        postId: postId,
        status: ApplicationStatus.interviewWaiting.rawValue,
        applicantName: "헤리",
        applicantBirthYear: 2001,
        applicantGender: "F",
        applicantDepartment: "컴퓨터공학과",
        applicantStudentId: "202112345",
        applicantPhone: "010-2345-6789",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user2",
        postId: postId,
        status: ApplicationStatus.interviewWaiting.rawValue,
        applicantName: "헤리",
        applicantBirthYear: 2001,
        applicantGender: "F",
        applicantDepartment: "컴퓨터공학과",
        applicantStudentId: "202112345",
        applicantPhone: "010-2345-6789",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user2",
        postId: postId,
        status: ApplicationStatus.interviewWaiting.rawValue,
        applicantName: "헤리",
        applicantBirthYear: 2001,
        applicantGender: "F",
        applicantDepartment: "컴퓨터공학과",
        applicantStudentId: "202112345",
        applicantPhone: "010-2345-6789",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),      Application(
        applicationId: UUID(),
        applicantUserId: "user2",
        postId: postId,
        status: ApplicationStatus.interviewWaiting.rawValue,
        applicantName: "헤리",
        applicantBirthYear: 2001,
        applicantGender: "F",
        applicantDepartment: "컴퓨터공학과",
        applicantStudentId: "202112345",
        applicantPhone: "010-2345-6789",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user3",
        postId: postId,
        status: ApplicationStatus.reviewWaiting.rawValue,
        applicantName: "카단",
        applicantBirthYear: 1999,
        applicantGender: "M",
        applicantDepartment: "경영학과",
        applicantStudentId: "201912345",
        applicantPhone: "010-3456-7890",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user3",
        postId: postId,
        status: ApplicationStatus.reviewWaiting.rawValue,
        applicantName: "카단",
        applicantBirthYear: 1999,
        applicantGender: "M",
        applicantDepartment: "경영학과",
        applicantStudentId: "201912345",
        applicantPhone: "010-3456-7890",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user3",
        postId: postId,
        status: ApplicationStatus.reviewWaiting.rawValue,
        applicantName: "카단",
        applicantBirthYear: 1999,
        applicantGender: "M",
        applicantDepartment: "경영학과",
        applicantStudentId: "201912345",
        applicantPhone: "010-3456-7890",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user3",
        postId: postId,
        status: ApplicationStatus.reviewWaiting.rawValue,
        applicantName: "카단",
        applicantBirthYear: 1999,
        applicantGender: "M",
        applicantDepartment: "경영학과",
        applicantStudentId: "201912345",
        applicantPhone: "010-3456-7890",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user3",
        postId: postId,
        status: ApplicationStatus.reviewWaiting.rawValue,
        applicantName: "카단",
        applicantBirthYear: 1999,
        applicantGender: "M",
        applicantDepartment: "경영학과",
        applicantStudentId: "201912345",
        applicantPhone: "010-3456-7890",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user3",
        postId: postId,
        status: ApplicationStatus.reviewWaiting.rawValue,
        applicantName: "카단",
        applicantBirthYear: 1999,
        applicantGender: "M",
        applicantDepartment: "경영학과",
        applicantStudentId: "201912345",
        applicantPhone: "010-3456-7890",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user4",
        postId: postId,
        status: ApplicationStatus.submitted.rawValue,
        applicantName: "벨고",
        applicantBirthYear: 2002,
        applicantGender: "M",
        applicantDepartment: "디자인학과",
        applicantStudentId: "202212345",
        applicantPhone: "010-4567-8901",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      ),
      Application(
        applicationId: UUID(),
        applicantUserId: "user5",
        postId: postId,
        status: ApplicationStatus.reviewCompleted.rawValue,
        isPassed: true,
        applicantName: "윈",
        applicantBirthYear: 2000,
        applicantGender: "F",
        applicantDepartment: "심리학과",
        applicantStudentId: "202012346",
        applicantPhone: "010-5678-9012",
        postTitle: "댄스 동아리 ○○ 모집합니다",
        postOrganization: "동아리명",
        postAuthorUserId: "author1"
      )
    ]
    
    for data in applicationData {
      do {
        _ = try await firesotreManager.create(data)
        print("application 테스트 데이터 생성 완료")
        
        await createTestQuestionAnswer(applicationId: data.applicationId.uuidString)
        print("\(data.applicationId.uuidString)와 세트인 questionAnswer 데이터 생성 완료")
      } catch {
        print("application 테스트 데이터 생성 실패")
      }
    }
  }
  
  private func createTestQuestionAnswer(applicationId: String) async {
    let testQuestionAnswers = [
      QuestionAnswer(
        answerId: UUID(),
        applicationId: applicationId,
        questionId: "",
        questionText: "햄버거 몇개 드시나요",
        answerText: "쥰나 맪아 믹어여 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ",
        createdAt: Timestamp(date: Date())
      ),
      QuestionAnswer(
        answerId: UUID(),
        applicationId: applicationId,
        questionId: "",
        questionText: "햄버거 몇개 드시나요",
        answerText: "쥰나 맪아 믹어여 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ",
        createdAt: Timestamp(date: Date())
      ),
      QuestionAnswer(
        answerId: UUID(),
        applicationId: applicationId,
        questionId: "",
        questionText: "햄버거 몇개 드시나요",
        answerText: "쥰나 맪아 믹어여 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ",
        createdAt: Timestamp(date: Date())
      )
    ]
    
    for answer in testQuestionAnswers {
      do {
        _ = try await firesotreManager.create(answer)
        print("QuestionAnswer 테스트 데이터 생성 완료: \(answer.questionText)")
      } catch {
        print("QuestionAnswer 테스트 데이터 생성 실패")
      }
    }
  }
}
