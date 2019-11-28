// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "River",
  products: [
    .library(name: "River", targets: ["River"]),
  ],
  dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.0")
  ],
  targets: [
    .target(name: "River", dependencies: ["RxSwift", "RxCocoa"]),
    .testTarget(name: "RiverTests", dependencies: ["River"]),
  ]
)
