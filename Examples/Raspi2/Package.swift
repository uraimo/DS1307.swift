import PackageDescription

let package = Package(
    name: "TestRTC",
    dependencies: [
        .Package(url: "https://github.com/uraimo/DS1307.swift.git",
                 majorVersion: 2)
    ]
)
