# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
# Generate Xcode project (required before building)
tuist generate

# Build
tuist build

# Run all tests
tuist test

# Run specific test class
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BabyFoodCareProjectTests/ProductsTests

# Run single test method
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BabyFoodCareProjectTests/ProductsTests/testInteractorGetProducts

# Clean generated files
tuist clean
```

## Architecture

iOS app using **VIPER with Coordinators** pattern. UIKit-based, Swift, iOS 17.0+.

### Module Structure
Each feature module contains:
- **Assembly** - Factory that creates and wires module components
- **Coordinator** - Handles navigation between modules
- **View** - UIViewController for UI
- **Presenter** - Mediates View/Interactor, handles navigation via Coordinator
- **Interactor** - Business logic and API calls

### Key Patterns

**Protocol-based communication** between layers:
```swift
protocol ProductsPresenterInput: AnyObject {
    func viewDidLoad()
    func obtainedData(products: [ProductsModel])
}

protocol ProductsPresenterOutput: AnyObject {
    func didSelectProduct(with productId: Int)
}
```

**Dependency injection** via Swinject with `@Injected` property wrapper:
```swift
@Injected var service: APIClient
```
Dependencies registered in `Dependency Injections.swift`.

**Tab-based navigation**: Products, Favorite, Account tabs managed by AppCoordinator.

### Services
- **Network Services** (`Services/Network Services/`) - APIClient with async/await
- **Cache Service** (`Services/Cache Service/`) - Data caching
- **Toast Service** (`Services/Toast Service/`) - User notifications

## Code Conventions

- Use `final` on all classes that don't need inheritance
- Use `weak var` for delegate/presenter references
- UI components use closure initialization pattern
- Auto Layout via `NSLayoutConstraint.activate([])`
- Always update UI on main thread with `DispatchQueue.main.async`
- Use `String(localized:)` for localization

**Note**: Existing module directories use "Modul" spelling - use "Module" in new code.

## Testing

Tests in `BabyFoodCareProjectTests/`. Use `MockAPIClient` with JSON fixture files for network mocking:
```swift
mockApiClient = MockAPIClient(fileName: "FoodResponseOne")
```
