// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "Magazine",
  platforms: [
    .iOS(.v10)
  ],
  products: [
    .library(name: "Magazine", targets: ["Magazine"])
  ],
  dependencies: [
    .package(url: "https://github.com/airbnb/MagazineLayout", from: "1.6.11")
  ],
  targets: [
    .target(name: "Magazine", dependencies: ["MagazineLayout"])
  ]
)
