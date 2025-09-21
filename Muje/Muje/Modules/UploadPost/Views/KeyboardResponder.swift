//
//  KeyboardResponder.swift
//  Muje
//
//  Created by Hong on 9/21/25.
//

import Combine

@Observable
final class KeyboardResponder {
  private var notificationCenter: NotificationCenter
  private(set) var currentHeight: CGFloat = 0
  
  init(center: NotificationCenter = .default) {
    notificationCenter = center
    notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  deinit {
    notificationCenter.removeObserver(self)
  }
  
  @objc func keyBoardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      currentHeight = keyboardSize.height
    }
  }
  
  @objc func keyBoardWillHide(notification: Notification) {
    currentHeight = 0
  }
}
