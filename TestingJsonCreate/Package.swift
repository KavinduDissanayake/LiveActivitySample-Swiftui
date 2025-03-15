// swift-tools-version: 5.10.0
import PackageDescription


let package = Package(
    name: "TestingJsonCreate",
    platforms: [.iOS(.v16)], // Ensure ActivityKit compatibility
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "JSONPayload",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)
