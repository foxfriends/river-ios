//
//  PresentCoordinator.swift
//  Created by Cameron Eldridge on 2019-11-28.
//

import UIKit
import RxSwift
import RxCocoa

public protocol PresentCoordinator: Coordinator {}

extension PresentCoordinator {
  func present(
    from presentingViewController: UIViewController,
    animated: Bool,
    completion: (() -> Void)?
  ) -> Signal<Yield> {
    Signal.deferred {
      let controller = self.loadRootViewController()
      presentingViewController.present(controller, animated: animated, completion: completion)
      let yields = self.begin(controller)
        .takeUntil(controller.rx.deallocated)
        .asSignal(onErrorRecover: { [weak presentingViewController] error in
          switch error {
          case let error as CoordinationError:
            presentingViewController?.dismiss(animated: error.animated)
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
          return .empty()
        })
      return Signal.concat([yields, .never()])
    }
  }
}
