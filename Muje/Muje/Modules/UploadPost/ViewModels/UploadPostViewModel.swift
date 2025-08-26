//
//  UploadPostViewModel.swift
//  Muje
//
//  Created by Air on 8/24/25.
//

import SwiftUI

@Observable
final class UploadPostViewModel {
    var currentStatus: UploadPostStatus = .input
    var isQuit: Bool = false
    var alertContents: [String] = ["지금까지 작성한 내용이 저장되지 않습니다\n나가시겠어요?", "중단하고 나가기", "계속 작성하기"]
}
