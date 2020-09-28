// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
  name: "NetworkService",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
  ],
  products: [
    .library(name: "NetworkService", targets: ["NetworkService"])
  ],
  dependencies: [
    .package(url: "https://github.com/0111b/Mock.git", from: "0.0.1"),
  ],
  targets: [
    .target(
      name: "NetworkService",
      dependencies: [
        "Mock"
      ]),
    .testTarget(
      name: "NetworkServiceTests",
      dependencies: ["NetworkService"]),
  ]
)
