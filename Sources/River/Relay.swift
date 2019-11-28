//
//  Relay.swift
//  Created by Cameron Eldridge on 2019-11-27.
//

import Foundation
import RxSwift
import RxCocoa

public protocol RelayCompatible {
  static func relay(initial: Self, current: Observable<Self>) -> Observable<Self>
}

@propertyWrapper
public final class Relay<Element: RelayCompatible> {
  private var disposeBag: DisposeBag?
  private let relay: BehaviorRelay<Element>
  private let relayErrors = PublishRelay<Error>()

  @inline(__always)
  public convenience init(_ value: Element) {
    self.init(wrappedValue: value)
  }

  public init(wrappedValue: Element) {
    relay = BehaviorRelay(value: wrappedValue)
    watchRelay()
  }

  public convenience init(default value: Element, deferred: Single<Element>) {
    self.init(wrappedValue: value, deferred: deferred)
  }

  public init(wrappedValue: Element, deferred: Single<Element>) {
    relay = BehaviorRelay(value: wrappedValue)
    _ = deferred
      .subscribe(
        onSuccess: { [weak self] newValue in self?.value = newValue },
        onError: { [relayErrors] error in relayErrors.accept(error) }
      )
  }

  private func watchRelay() {
    disposeBag = DisposeBag()
    relayChanges().bind(to: relay).disposed(by: disposeBag!)
  }

  private func relayChanges() -> Observable<Element> {
    return Element.relay(initial: relay.value, current: relay.asObservable())
      .catchError { [unowned self, relayErrors] error in
        relayErrors.accept(error)
        return self.relayChanges()
      }
  }

  public private(set) lazy var errors: Signal<Error> = relayErrors.asSignal()

  @inline(__always)
  public var wrappedValue: Element { get { value } set { value = newValue } }
  public var value: Element {
    get { relay.value }
    set {
      relay.accept(newValue)
      watchRelay()
    }
  }

  @inline(__always)
  public var projectedValue: Driver<Element> { driver }
  public private(set) lazy var driver: Driver<Element> = relay.asDriver()
}

// MARK: - Codable
extension Relay: Encodable where Element: Encodable {
  public func encode(to encoder: Encoder) throws {
    try wrappedValue.encode(to: encoder)
  }
}

extension Relay: Decodable where Element: Decodable {
  public convenience init(from decoder: Decoder) throws {
    try self.init(wrappedValue: Element(from: decoder))
  }
}
