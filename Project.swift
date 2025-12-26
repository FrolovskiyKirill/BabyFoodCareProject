import ProjectDescription

let project = Project(
    name: "BabyFoodCareProject",
    organizationName: "Kirill.Frolovskiy",
    packages: [
        .remote(
            url: "https://github.com/Swinject/Swinject.git",
            requirement: .upToNextMajor(from: "2.10.0")
        )
    ],
    settings: .settings(
        base: [
            "IPHONEOS_DEPLOYMENT_TARGET": "17.0",
            "SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG $(inherited)",
            "SWIFT_OPTIMIZATION_LEVEL": "-Onone"
        ],
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ],
        defaultSettings: .recommended
    ),
    targets: [
        .target(
            name: "BabyFoodCareProject",
            destinations: .iOS,
            product: .app,
            bundleId: "Kirill.Frolovskiy.BabyFoodCareProject",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ],
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UISupportedInterfaceOrientations": "UIInterfaceOrientationPortrait",
                    "UISupportedInterfaceOrientations_iPad": "UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown"
                ]
            ),
            sources: [
                "BabyFoodCareProject/Application/**/*.swift",
                "BabyFoodCareProject/Cells/**/*.swift",
                "BabyFoodCareProject/Dependency Injection/**/*.swift",
                "BabyFoodCareProject/Entities/**/*.swift",
                "BabyFoodCareProject/Modules/**/*.swift",
                "BabyFoodCareProject/Navigation/**/*.swift",
                "BabyFoodCareProject/Services/**/*.swift"
            ],
            resources: [
                "BabyFoodCareProject/Resources/Assets.xcassets",
                "BabyFoodCareProject/Resources/Base.lproj/LaunchScreen.storyboard",
                "BabyFoodCareProject/Resources/Localizable.xcstrings"
            ],
            dependencies: [
                .package(product: "Swinject")
            ],
            settings: .settings(
                base: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "WUPLHJKG9Y",
                    "MARKETING_VERSION": "1.0",
                    "CURRENT_PROJECT_VERSION": "1",
                    "SWIFT_VERSION": "5.0",
                    "SWIFT_EMIT_LOC_STRINGS": true,
                    "LOCALIZATION_PREFERS_STRING_CATALOGS": true,
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "INFOPLIST_KEY_CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)"
                ]
            )
        ),
        .target(
            name: "BabyFoodCareProjectTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "Kirill.Frolovskiy.BabyFoodCareProjectTests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: [
                "BabyFoodCareProjectTests/**/*.swift"
            ],
            resources: [
                "BabyFoodCareProjectTests/**/*.json"
            ],
            dependencies: [
                .target(name: "BabyFoodCareProject")
            ],
            settings: .settings(
                base: [
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "WUPLHJKG9Y",
                    "MARKETING_VERSION": "1.0",
                    "CURRENT_PROJECT_VERSION": "1",
                    "SWIFT_VERSION": "5.0",
                    "SWIFT_EMIT_LOC_STRINGS": false,
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "TEST_HOST": "$(BUILT_PRODUCTS_DIR)/BabyFoodCareProject.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/BabyFoodCareProject"
                ]
            )
        ),
        .target(
            name: "BabyFoodCareProjectUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "Kirill.Frolovskiy.BabyFoodCareProjectUITests",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .default,
            sources: .paths(["BabyFoodCareProjectUITests/**"]),
            dependencies: [
                .target(name: "BabyFoodCareProject")
            ],
            settings: .settings(
                base: [
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "WUPLHJKG9Y",
                    "MARKETING_VERSION": "1.0",
                    "CURRENT_PROJECT_VERSION": "1",
                    "SWIFT_VERSION": "5.0",
                    "SWIFT_EMIT_LOC_STRINGS": false,
                    "TARGETED_DEVICE_FAMILY": "1,2",
                    "TEST_TARGET_NAME": "BabyFoodCareProject"
                ]
            )
        )
    ]
)
