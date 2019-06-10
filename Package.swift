// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "app",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "carthage-cache", targets: ["CarthageCache"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha"),
        .package(url: "https://github.com/jakeheis/Shout.git", from: "0.5.0"),
        .package(url: "https://github.com/kareman/SwiftShell.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "CarthageCache",
            dependencies: [
                "Vapor"
            ]
        )
    ]
)

