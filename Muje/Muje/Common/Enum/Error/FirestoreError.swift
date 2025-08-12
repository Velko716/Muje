//
//  FirestoreError.swift
//  Muje
//
//  Created by 김진혁 on 8/1/25.
//

import Foundation

enum FirestoreError: LocalizedError {
    case addFailed(underlying: Swift.Error)
    case fetchFailed(underlying: Swift.Error)
    case deleteFailed(underlying: Swift.Error)
    case updateFailed(underlying: Swift.Error)
    
    case decodingFailed
    case encodingFailed
    
    var errorDescription: String? {
        switch self {
        case .addFailed(let error):
            "데이터를 추가하는데 실패했습니다: \(error)"
        case .fetchFailed(let error):
            "데이터를 읽어오는데 실패했습니다: \(error)"
        case .deleteFailed(let error):
            "데이터를 삭제하는데 실패했습니다: \(error)"
        case .updateFailed(let error):
            "데이터를 업데이트하는데 실패했습니다: \(error)"
        case .encodingFailed:
            "데이터를 encoding하는데 실패했습니다"
        case .decodingFailed:
            "데이터를 decoding하는데 실패했습니다"
        }
    }
}
