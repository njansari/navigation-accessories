// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "NavigationAccessories",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(name: "NavigationAccessories", targets: ["NavigationAccessories"])
    ],
    targets: [
        .target(name: "NavigationAccessories")
    ]
)
