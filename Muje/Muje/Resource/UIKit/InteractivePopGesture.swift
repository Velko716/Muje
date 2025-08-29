//
//  InteractivePopGesture.swift
//  Muje
//
//  Created by 김진혁 on 8/19/25.
//

import UIKit
import SwiftUI

struct InteractivePopGesture: UIViewControllerRepresentable {
  func makeCoordinator() -> Coordinator { Coordinator() }

  func makeUIViewController(context: Context) -> UIViewController {
    let vc = UIViewController()
      
    DispatchQueue.main.async {
      guard let nav = vc.navigationController else { return }
      context.coordinator.attach(to: nav)
    }
    return vc
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

  final class Coordinator: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    private weak var nav: UINavigationController?
    private var interaction: UIPercentDrivenInteractiveTransition?
    private var hasBegan = false
    private let startThreshold: CGFloat = 24
    private lazy var pan: UIPanGestureRecognizer = {
      let g = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
      g.maximumNumberOfTouches = 1
      g.delegate = self
      return g
    }()

    func attach(to nav: UINavigationController) {
      guard self.nav !== nav else { return }
      self.nav = nav
      nav.interactivePopGestureRecognizer?.isEnabled = true
      if !(nav.view.gestureRecognizers ?? []).contains(where: { $0 === pan }) {
        nav.view.addGestureRecognizer(pan)
      }
    }

    // MARK: - Gesture
    @objc private func handlePan(_ g: UIPanGestureRecognizer) {
      guard let nav, nav.viewControllers.count > 1 else { return }

      let view = nav.view!
      let translationX = g.translation(in: view).x
      let width = view.bounds.width

      func normalizedProgress() -> CGFloat {
        let denom = max(1, width - startThreshold)
        let p = (translationX - startThreshold) / denom
        return max(0, min(1, p))
      }

      switch g.state {
      case .began:
        hasBegan = false

      case .changed:
        if !hasBegan {
          if translationX > startThreshold {
            hasBegan = true
            interaction = UIPercentDrivenInteractiveTransition()
            interaction?.completionCurve = .easeOut
            nav.delegate = self
            nav.popViewController(animated: true) // start pop; we'll drive it below
          } else {
            return
          }
        }
        interaction?.update(normalizedProgress())

      case .ended, .cancelled:
        if hasBegan {
          let velocityX = g.velocity(in: view).x
          let progress = normalizedProgress()
          let shouldFinish = (progress > 0.33) || (velocityX > 600)
          if shouldFinish {
            interaction?.finish()
          } else {
            interaction?.cancel()
          }
        }
        interaction = nil
        hasBegan = false

      default:
        break
      }
    }

    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
      interaction
    }

    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      guard let nav,
            nav.viewControllers.count > 1,
            let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
      let v = pan.velocity(in: nav.view)
      return v.x > abs(v.y) && v.x > 0
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      return true
    }
  }
}
