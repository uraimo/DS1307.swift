// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DS1307",
    products: [
        .library(
            name: "DS1307",
            targets: ["DS1307"]),
    ],
    dependencies: [
        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "DS1307",
            dependencies: ["SwiftyGPIO"],
            path: ".",
            sources: ["Sources"])
    ]
)