//
//  CoordinationError.swift
//  Created by Cameron Eldridge on 2019-12-03.
//

protocol CoordinationError: Error {
  var animated: Bool { get }
}

extension CoordinationError {
  var animated: Bool { true }
}
