// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TreeSitterMake",
    products: [
        .library(name: "TreeSitterMake", targets: ["TreeSitterMake"]),
    ],
    targets: [
        .target(
            name: "TreeSitterMake",
            path: ".",
            sources: [
                "src/parser.c",
            ],
            resources: [
                .copy("queries"),
            ],
            publicHeadersPath: "bindings/c",
            cSettings: [.headerSearchPath("src")]
        ),
    ],
    cLanguageStandard: .c11
)
