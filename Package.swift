// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport
import SwiftUI

let package = Package(
    name: "KNMacros",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "KNMacros",
            targets: ["KNMacros"]
        ),
        .library(
            name: "KNMetamacros",
            targets: ["KNMetamacros"]
        ),
        .library(
            name: "KNMacroHelpers",
            targets: ["KNMacroHelpers"]
        ),
        .executable(
            name: "KNMacrosClient",
            targets: ["KNMacrosClient"]
        ),
    ],
    dependencies: [
        // Depend on the latest Swift 5.9 prerelease of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", revision: "7617b70fb8addcf29ab4d18f7e90d88bbe07851d"),
    ],
    targets: [
        .macro(
            name: "KNMacrosMacros",
            dependencies: [
                "KNMetamacros",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .macro(
            name: "KNMetamacrosMacros",
            dependencies: [
                "KNMacroHelpers",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        .target(name: "KNMacros", dependencies: ["KNMacrosMacros"]),
        .target(name: "KNMetamacros", dependencies: ["KNMetamacrosMacros"]),
        .target(name: "KNMacroHelpers", dependencies: [
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        ]),

        .executableTarget(
            name: "KNMacrosClient",
            dependencies: [
                "KNMacros",
                "KNMetamacros", // These should be transitively included but add explicitly just because.
                "KNMacroHelpers",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),

        .testTarget(
            name: "KNMacrosTests",
            dependencies: [
                "KNMacrosMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),

        .testTarget(
            name: "KNMetamacrosTests",
            dependencies: [
                "KNMetamacrosMacros",
                "KNMacroHelpers",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),

        .testTarget(
            name: "KNMacroHelpersTests",
            dependencies: [
                "KNMacroHelpers",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)

struct Previews_Package_LibraryContent: LibraryContentProvider {
    var views: [LibraryItem] {
        LibraryItem(/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/)
    }
}
