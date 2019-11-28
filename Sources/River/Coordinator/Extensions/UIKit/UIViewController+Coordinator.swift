//
//  UIViewController+Coordinator.swift
//  Created by Cameron Eldridge on 2019-11-28.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIViewController {
  func present<C: PresentCoordinator>(coordinator: C, animated: Bool = true, completion: (() -> Void)? = nil) -> Signal<C.Yield> {
    coordinator.present(from: self, animated: animated, completion: completion)
  }
}

public extension Reactive where Base: UIViewController {
  func present<C: PresentCoordinator>(animated: Bool = true) -> (C) -> Signal<C.Yield> {
    return { [weak base] coordinator in base?.present(coordinator: coordinator, animated: animated) ?? .empty() }
  }
}
