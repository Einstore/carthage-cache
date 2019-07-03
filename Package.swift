// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "app",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "carthage-server", targets: ["CarthageServer"]),
        .executable(name: "carthage-cache", targets: ["CarthageCache"]),
        .executable(name: "github-info", targets: ["GitHubInfo"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-alpha"),
//        .package(url: "https://github.com/jakeheis/Shout.git", from: "0.5.0"),
//        .package(url: "https://github.com/kareman/SwiftShell.git", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "CarthageServer",
            dependencies: [
                "Vapor"
            ]
        ),
        .target(
            name: "CarthageCache",
            dependencies: [
                "Vapor",
                "GitHubKit"
            ]
        ),
        .target(
            name: "GitHubKit",
            dependencies: [
                "Vapor"
            ]
        ),
        .target(
            name: "GitHubInfo",
            dependencies: [
                "Vapor",
                "GitHubKit"
            ]
        )
    ]
)

