//
//  Emitter.swift
//  Created by Cameron Eldridge on 2019-12-04.
//

import RxCocoa

@propertyWrapper
public final class Emitter<Element> {
  private let relay = PublishRelay<Element>()

  public init() {}

  public var wrappedValue: (Element) -> Void {
    return { [weak self] event in self?.emit(event) }
  }

  public var projectedValue: Signal<Element> { signal }
  public private(set) lazy var signal = relay.asSignal()

  func emit(_ event: Element) {
    relay.accept(event)
  }
}
