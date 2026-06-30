// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AppRouter",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "AppRouter", targets: ["AppRouter"]),
    ],
    targets: [
        .target(name: "AppRouter"),
        .testTarget(name: "AppRouterTests", dependencies: ["AppRouter"]),
    ]
)
