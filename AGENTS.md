# AGENTS.md

This document provides guidelines for agentic coding assistants working in the BabyFoodCareProject repository.

## Project Overview

iOS app built with UIKit using VIPER architecture with Coordinators pattern. The project helps users track baby food products, their nutritional information, allergens, and serving recommendations.

**Tech Stack:**
- Language: Swift
- UI Framework: UIKit
- Dependency Injection: Swinject
- Mocking: Local Mockable protocol
- Project Generation: Tuist
- Package Manager: Swift Package Manager (via Tuist)

## Build, Test, and Lint Commands

### Project Generation
```bash
# Generate Xcode project with Tuist
tuist generate

# Clean generated project
tuist clean

# Clean all caches
tuist clean --all
```

### Building
```bash
# Build with Tuist
tuist build

# Or use xcodebuild on generated project
xcodebuild -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject build
```

### Testing
```bash
# Run tests with Tuist
tuist test

# Or use xcodebuild on generated project
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16'

# Run specific test class
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BabyFoodCareProjectTests/ProductsTests

# Run single test method
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BabyFoodCareProjectTests/ProductsTests/testInteractorGetProducts
```

### Tuist Installation
```bash
# Install Tuist (macOS)
curl -Ls https://install.tuist.io | bash

# Or via Homebrew
brew install tuist

# Verify installation
tuist version
```

### Testing
```bash
# Run all tests
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16'

# Run specific test class
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BabyFoodCareProjectTests/ProductsTests

# Run single test method
xcodebuild test -project BabyFoodCareProject.xcodeproj -scheme BabyFoodCareProject -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BabyFoodCareProjectTests/ProductsTests/testInteractorGetProducts

# Run tests with SwiftPM
swift test
```

### Dependencies
```bash
# Resolve Swift Package dependencies
xcodebuild -resolvePackageDependencies

# Or use swift package manager
swift package resolve
```

## Architecture - VIPER with Coordinators

Each module follows VIPER structure:
- **View**: UIViewController subclass, handles UI logic
- **Interactor**: Business logic, API calls, data transformation
- **Presenter**: Mediates between View and Interactor, handles navigation via Coordinator
- **Assembly**: Creates module components, wires them together
- **Coordinator**: Handles navigation and module flow

### Module Structure Pattern
```
ModuleName/
  ModuleNameAssembly.swift
  ModuleNameCoordinator.swift
  ModuleNameInteractor.swift
  ModuleNamePresenter.swift
  ModuleNameView.swift
```

### Protocol-Based Communication

Define Input/Output protocols for clean separation:
```swift
// Presenter input (what presenter receives)
protocol ProductsPresenterInput: AnyObject {
    func viewDidLoad()
    func obtainedData(products: [ProductsModel])
}

// Presenter output (what presenter emits)
protocol ProductsPresenterOutput: AnyObject {
    func didSelectProduct(with productId: Int)
}
```

View protocols follow same pattern: ViewInput/ViewOutput.

### Dependency Injection

Use Swinject container via @Injected property wrapper:
```swift
@Injected var service: APIClient
```

All dependencies are registered in Dependency Injections.swift.

## Code Style Guidelines

### File Naming
- Use CamelCase with first letter capitalized: `ProductsView.swift`
- Protocol names follow same convention: `ProductsPresenterInput`, `ProductsPresenterOutput`
- Avoid typos (note: existing code has "Modul" - use "Module" in new code)

### Class Declarations
- Use `final` on all classes that don't need inheritance
- Declare access modifiers explicitly
- Place MARK comments for organization

```swift
final class ProductsView: UIViewController {
    //MARK: Properties
    var presenter: ProductsPresenterInput?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    //MARK: Methods
    func setupInitialState() { }
}
```

### Extensions
Use extensions to organize conformances:
```swift
// MARK: ProductsView: UICollectionViewDelegate
extension ProductsView: UICollectionViewDelegate {
    // Implementation
}

// MARK: ProductsView: ProductsViewOutput
extension ProductsView: ProductsViewOutput {
    // Implementation
}
```

### Properties
- Use `weak var` for delegate/presenter relationships to prevent retain cycles
- Use `lazy var` for complex object initialization
- Private properties for internal state, public for dependencies

```swift
weak var presenter: ProductsPresenterInput?
private var products: [ProductsModel] = []
private lazy var dataSource = makeDataSource()
```

### UI Components
Define UI components using closure pattern with explicit configuration:
```swift
private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 8
    imageView.clipsToBounds = true
    return imageView
}()
```

### Auto Layout
Use NSLayoutConstraint with explicit activation:
```swift
private func setupLayout() {
    NSLayoutConstraint.activate([
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
    ])
}
```

### Async/Await
Use async/await for network operations:
```swift
func getData() {
    Task.init {
        do {
            self.products = try await APIClient.getProducts()
            self.presenter?.obtainedData(products: products)
        } catch {
            print("Fetching establishments failed with error \(error)")
        }
    }
}
```

### Completion Handlers
Use Result type for completion handlers:
```swift
func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
    Task {
        do {
            let imageData = try await apiImageClient.fetchImage(urlString: urlString)
            completion(.success(imageData))
        } catch {
            completion(.failure(error))
        }
    }
}
```

### Main Thread Updates
Always update UI on main thread:
```swift
DispatchQueue.main.async {
    self.view?.applySnapshot(model: products, animatingDifferences: true)
}
```

### Models
- Use structs for data models
- Conform to Codable for JSON parsing
- Conform to Hashable for collection operations
- Use private CodingKeys enum for key mapping if needed

```swift
struct ProductsModel: Codable {
    let id: Int
    let title: String
    // ...
}
```

### Enums
Use Swift-style enums with associated values:
```swift
enum APIRouter {
    case getProducts
    case getProductDetails(poductID: Int)

    var host: String {
        switch self {
        case .getProducts, .getProductDetails:
            return "makarbass.ru"
        }
    }
}
```

### Typealias
Use typealias for complex types to improve readability:
```swift
typealias DataSource = UICollectionViewDiffableDataSource<Section, ProductsModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ProductsModel>
```

### Localization
Use String(localized:) for localized strings:
```swift
searchController.searchBar.placeholder = String(localized: "Search Products")
title = "Baby Food Care"
```

### Error Handling
- Print errors with context (Russian in existing code, but prefer English)
- Consider user-facing error messages in production
- Use Result types for error propagation
- Don't silently ignore errors

### Comments
- Keep comments minimal
- Use TODO markers for future work
- Let code be self-documenting with clear naming
- Example TODO: `// TODO: map to viewmodel`

### Cell Registration
Define static identifier for reusable cells:
```swift
final class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    // ...
}

collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
```

### Mock Testing
Use MockAPIClient with JSON fixture files for testing. Mockable protocol is defined in BabyFoodCareProjectTests/Mockable.swift:
```swift
mockApiClient = MockAPIClient(fileName: "FoodResponseOne")
```

Test fixtures are in BabyFoodCareProjectTests/*.json.

### Common Patterns

1. **Assembly Pattern**: Create all module components in static makeModule() method
2. **Coordinator Navigation**: Call coordinator methods for navigation, not view controllers directly
3. **View-Presenter Binding**: In Assembly, set weak references to prevent retain cycles
4. **Diffable DataSource**: Use UICollectionViewDiffableDataSource for lists
5. **Compositional Layout**: Use UICollectionViewCompositionalLayout for complex layouts

### Anti-Patterns to Avoid
- Don't use force unwrapping (!) unless absolutely necessary
- Don't access UI from background threads
- Don't create retain cycles with strong delegate references
- Don't put business logic in View controllers
- Don't handle UI updates in Interactors
- Don't create view controllers directly from other view controllers (use coordinators)

## Working with Tests

- Tests are in BabyFoodCareProjectTests/ directory
- Use @testable import BabyFoodCareProject
- Set up mock objects in setUp() method
- Mock network responses using MockAPIClient with JSON files
- Use XCTAssertEqual for assertions
- Keep tests focused on single behavior

