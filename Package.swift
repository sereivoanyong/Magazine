// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "Magazine",
  platforms: [.iOS(.v11)],
  products: [
    .library(name: "Magazine", targets: ["Magazine"])
  ],
  dependencies: [
    .package(url: "https://github.com/airbnb/MagazineLayout", from: "1.5.4")
  ],
  targets: [
    .target(name: "Magazine", dependencies: ["MagazineLayout"])
  ],
  swiftLanguageVersions: [.v5]
)
