//
//  RootCoordinator.swift
//  Created by Cameron Eldridge on 2019-11-28.
//

import UIKit
import RxCocoa

public protocol RootCoordinator: Coordinator {}

extension RootCoordinator {
  func becomeRoot(of window: UIWindow) -> Signal<Yield> {
    Signal.deferred {
      let controller = self.loadRootViewController()
      window.rootViewController = controller
      let yields = self.begin(controller)
        .takeUntil(controller.rx.deallocated)
        .asSignal(onErrorRecover: { error in
          #if DEBUG
          // Looks like your RootCoordinator has yielded an error, which we are unable to recover from. You might want to
          // insert a breakpoint here to help debug where that error comes from.
          fatalError(error.localizedDescription)
          #else
          print(error)
          return .empty()
          #endif
        })
      return Signal.concat([yields, .never()])
    }
  }
}
