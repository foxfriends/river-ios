//
//  UIWindow+Coordinator.swift
//  Created by Cameron Eldridge on 2019-11-28.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIWindow {
  func setRootCoordinator<C: RootCoordinator>(_ coordinator: C) -> Signal<C.Yield> {
    coordinator.becomeRoot(of: self)
  }
}

public extension Reactive where Base: UIWindow {
  func setRootCoordinator<C: RootCoordinator>() -> (C) -> Signal<C.Yield> {
    return { [weak base] coordinator in base?.setRootCoordinator(coordinator) ?? .empty() }
  }
}
