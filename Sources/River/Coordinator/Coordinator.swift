//
//  Coordinator.swift
//  Created by Cameron Eldridge on 2019-11-27.
//

import UIKit
import RxSwift

public protocol Coordinator {
  associatedtype RootViewController: UIViewController
  associatedtype Yield

  func makeRootViewController() -> RootViewController
  func begin(_ rootViewController: RootViewController) -> Observable<Yield>
}

extension Coordinator {
  func loadRootViewController() -> RootViewController {
    let controller = makeRootViewController()
    _ = controller.view // access the view property to cause it to be loaded
    return controller
  }
}
