import PackageDescription

let package = Package(
    name: "TestRTC",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/uraimo/DS1307.swift.git",
                 majorVersion: 1)
    ]
)
