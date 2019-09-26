// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "TestRTC",
    dependencies: [
        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", from: "1.0.0"),
        .package(url: "https://github.com/uraimo/DS1307.swift.git",from: "2.0.0")
    ],
    targets: [
        .target(name: "TestRTC", 
                dependencies: ["SwiftyGPIO","DS1307"],
                path: "Sources")
    ]
) 