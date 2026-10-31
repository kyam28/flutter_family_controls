// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_family_controls",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "flutter-family-controls", targets: ["flutter_family_controls"])
    ],
    dependencies: [
        // Resolved by the Flutter tool when the package is built as part of an app.
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "flutter_family_controls",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
