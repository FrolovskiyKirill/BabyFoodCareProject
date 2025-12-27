//
//  ProductsTests.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 16.03.2024.
//

import XCTest
@testable import BabyFoodCareProject

final class ProductsTests: XCTestCase {
    
    var presenter: ProductsPresenter!
    var mockView: MockProductsView!
    var mockApiClient: ProductsProtocol!
    var mockImageClient: ImageProtocol!
    var mockCoordinator: MockProductsCoordinator!
    
    override func setUp() {
        super.setUp()
        mockView = MockProductsView()
        mockApiClient = MockAPIClient(fileName: "FoodResponseOne")
        mockImageClient = APIImageClient()
        mockCoordinator = MockProductsCoordinator(type: .products, navigationController: UINavigationController())
        
        presenter = ProductsPresenter(
            apiClient: mockApiClient,
            apiImageClient: mockImageClient,
            coordinator: mockCoordinator
        )
        presenter.view = mockView
    }
    
    let productModelMock = ProductsModel(
        id: 8,
        title: "Test Pepper",
        foodType: "Vegetables",
        description: "123",
        imageURL: "123",
        foodTypeImageURL: "123",
        monthFrom: 6,
        allergen: true,
        allergenDescription: nil,
        withWarning: true,
        warningNote: nil,
        howToServe: nil,
        howToServeImageURL: nil,
        calories: 0,
        protein: 0,
        fats: 0,
        carbs: 0
    )
    
    // MARK: - Test 1: Load products successfully from API
    func testGetProductsSuccess() async throws {
        let products = try await mockApiClient.getProducts()
        
        XCTAssertEqual(products.first?.id, productModelMock.id)
        XCTAssertEqual(products.first?.title, productModelMock.title)
        XCTAssertEqual(products.first?.foodType, productModelMock.foodType)
    }
    
    // MARK: - Test 2: Presenter calls setupInitialState on View when viewDidLoad
    func testPresenterCallsSetupInitialState() {
        presenter.viewDidLoad()
        
        XCTAssertTrue(mockView.setupInitialStateCalled, "setupInitialState should be called on viewDidLoad")
    }
    
    // MARK: - Test 3: Presenter updates View with snapshot after loading data
    func testPresenterUpdatesViewWithData() async throws {
        presenter.viewDidLoad()
        
        // Wait for async data loading
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        XCTAssertTrue(mockView.applySnapshotCalled, "applySnapshot should be called after data loads")
        XCTAssertGreaterThan(mockView.lastSnapshot.count, 0, "Snapshot should contain products")
        XCTAssertEqual(mockView.lastSnapshot.first?.id, productModelMock.id)
    }
    
    // MARK: - Test 4: Search products filters correctly
    func testSearchProducts() async throws {
        // Load initial data
        presenter.viewDidLoad()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let initialCount = mockView.lastSnapshot.count
        XCTAssertGreaterThan(initialCount, 0, "Should have initial products")
        
        // Search for "Pepper"
        presenter.searchProducts(with: "Pepper")
        
        XCTAssertTrue(mockView.applySnapshotCalled)
        XCTAssertLessThanOrEqual(mockView.lastSnapshot.count, initialCount, "Filtered results should be less than or equal to initial")
        
        // All results should contain "pepper" (case insensitive)
        for product in mockView.lastSnapshot {
            XCTAssertTrue(product.title.lowercased().contains("pepper"), "Product '\(product.title)' should contain 'pepper'")
        }
    }
    
    // MARK: - Test 5: Reset search restores all products
    func testResetSearch() async throws {
        // Load initial data
        presenter.viewDidLoad()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let initialCount = mockView.lastSnapshot.count
        
        // Search to filter
        presenter.searchProducts(with: "Pepper")
        _ = mockView.lastSnapshot.count
        
        // Reset search
        presenter.resetSearch()
        
        XCTAssertEqual(mockView.lastSnapshot.count, initialCount, "Reset should restore all products")
    }
    
    // MARK: - Test 6: Navigation to product details
    func testNavigationToProductDetails() {
        let testProductId = 42
        
        presenter.didSelectProduct(with: testProductId)
        
        XCTAssertTrue(mockCoordinator.showDetailsCalled, "showDetails should be called on coordinator")
        XCTAssertEqual(mockCoordinator.lastProductId, testProductId, "Product ID should match")
    }
    
    // MARK: - Test 7: Search with non-matching query returns empty results
    func testSearchWithNonMatchingQueryReturnsEmpty() async throws {
        // Load initial data
        presenter.viewDidLoad()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertGreaterThan(mockView.lastSnapshot.count, 0, "Should have initial products")
        
        // Search with query that won't match anything
        presenter.searchProducts(with: "ZZZZNONEXISTENTPRODUCTZZZ")
        
        // Should show no products
        XCTAssertEqual(mockView.lastSnapshot.count, 0, "Non-matching search should return empty results")
    }
    
    // MARK: - Test 8: Search is case insensitive
    func testSearchIsCaseInsensitive() async throws {
        // Load initial data
        presenter.viewDidLoad()
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // Search with different cases
        presenter.searchProducts(with: "PEPPER")
        let upperCaseCount = mockView.lastSnapshot.count
        
        presenter.searchProducts(with: "pepper")
        let lowerCaseCount = mockView.lastSnapshot.count
        
        presenter.searchProducts(with: "PePpEr")
        let mixedCaseCount = mockView.lastSnapshot.count
        
        XCTAssertEqual(upperCaseCount, lowerCaseCount, "Search should be case insensitive")
        XCTAssertEqual(lowerCaseCount, mixedCaseCount, "Search should be case insensitive")
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockApiClient = nil
        mockImageClient = nil
        mockCoordinator = nil
        super.tearDown()
    }
}
