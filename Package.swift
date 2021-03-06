// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "Localization",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(
            name: "Language",
            targets: [
                "Language"
            ]
        ),
        .library(
            name: "LocalizationManager",
            targets: [
                "LocalizationManager"
            ]
        )
    ],
    dependencies: [
        .package(name: "Core", url: "https://github.com/kutchie-pelaez-packages/Core.git", .branch("master")),
        .package(name: "Logging", url: "https://github.com/kutchie-pelaez-packages/Logging.git", .branch("master")),
        .package(name: "Tweaks", url: "https://github.com/kutchie-pelaez-packages/Tweaks.git", .branch("master")),
        .package(name: "Yams", url: "https://github.com/jpsim/Yams.git", from: "4.0.6")
    ],
    targets: [
        .target(
            name: "LocalizationManager",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Logger", package: "Logging"),
                .product(name: "Tweak", package: "Tweaks"),
                .product(name: "Yams", package: "Yams"),
                .target(name: "Language")
            ]
        ),
        .target(
            name: "Language",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "Tweak", package: "Tweaks")
            ]
        )
    ]
)
