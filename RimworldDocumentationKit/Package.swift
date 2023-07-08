// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RimworldDocumentationKit",
	platforms: [
		.macOS(.v14),
		.iOS(.v17),
	],
    products: [
        .library(
            name: "RimworldDocumentationKit",
            targets: ["RimworldDocumentationKit"]),
    ],
    targets: [
        .target(
            name: "RimworldDocumentationKit",
		resources: [
			.copy("Preview/latest.json")
		]),
        .testTarget(
            name: "RimworldDocumentationKitTests",
            dependencies: ["RimworldDocumentationKit"]),
    ]
)
