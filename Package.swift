// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "PromptDadi",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "PromptDadi",
            targets: ["PromptDadi"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "PromptDadi",
            path: "PromptDadi",
            exclude: ["Info.plist", "Assets.xcassets", "Assets.xcassets/Contents.json", "Assets.xcassets/AppIcon.appiconset", "Assets.xcassets/AccentColor.colorset"]
        )
    ]
) 