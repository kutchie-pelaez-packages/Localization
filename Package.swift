// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "LocalizationManager",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(name: "LocalizationManager", targets: ["LocalizationManager"]),
        .library(name: "Language", targets: ["Language"])
    ],
    dependencies: [
        .package(name: "Core", url: "https://github.com/kutchie-pelaez-packages/Core", .branch("master"))
    ],
    targets: [
        .target(
            name: "LocalizationManager",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .target(name: "Language")
            ]
        ),
        .target(
            name: "Language",
            dependencies: [
                .product(name: "Core", package: "Core")
            ]
        )
    ]
)
