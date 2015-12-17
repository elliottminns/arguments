import PackageDescription

let package = Package(
    name: "Arguments",
    targets: [
        Target(
            name: "ArgumentsExample",
            dependencies: [.Target(name: "Arguments")]),
        Target(
            name: "Arguments")
    ]
)
