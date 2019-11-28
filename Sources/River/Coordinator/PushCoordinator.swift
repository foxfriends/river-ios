//
//  PushCoordinator.swift
//  Created by Cameron Eldridge on 2019-11-28.
//

import UIKit
import RxCocoa

public protocol PushCoordinator: Coordinator {}

extension PushCoordinator {
  func push(to pushingNavigationController: UINavigationController, animated: Bool) -> Signal<Yield> {
    Signal.deferred {
      let controller = self.loadRootViewController()
      let pushingViewController = pushingNavigationController.viewControllers.last
      pushingNavigationController.pushViewController(controller, animated: animated)
      let yields = self.begin(controller)
        .takeUntil(controller.rx.deallocated)
        .asSignal(onErrorRecover: { [weak pushingNavigationController, weak pushingViewController] error in
          switch error {
          case let error as CoordinationError:
            if let pushingViewController = pushingViewController {
              pushingNavigationController?.popToViewController(pushingViewController, animated: error.animated)
            }
          default:
            #if DEBUG
            // Looks like your Coordinator has yielded an error which was not marked as a CoordinationError. This is a
            // situation which is most likely a bug. If you did intend to yield an error to take advantage of the
            // unwinding behaviour, please use an appropriate error which conforms to the CoordinationError protocol.
            fatalError(error.localizedDescription)
            #else
            print(error)
            #endif
          }
          return .never()
        })
      return Signal.concat([yields, .never()])
    }
  }
}
