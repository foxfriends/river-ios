//
//  UINavigationController+Coordinator.swift
//  Created by Cameron Eldridge on 2019-11-28.
//

import UIKit
import RxSwift
import RxCocoa

public extension UINavigationController {
  func push<C: PushCoordinator>(coordinator: C, animated: Bool = true) -> Signal<C.Yield> {
    coordinator.push(to: self, animated: animated)
  }
}

public extension Reactive where Base: UINavigationController {
  func push<C: PushCoordinator>(animated: Bool = true) -> (C) -> Signal<C.Yield> {
    return { [weak base] coordinator in base?.push(coordinator: coordinator, animated: animated) ?? .empty() }
  }
}
