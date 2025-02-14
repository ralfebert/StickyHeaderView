// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "StickyHeaderView",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: "StickyHeaderView",
            targets: ["StickyHeaderView"]
        ),
    ],
    targets: [
        .target(
            name: "StickyHeaderView"),
    ]
)
