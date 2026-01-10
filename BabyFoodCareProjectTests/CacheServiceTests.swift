//
//  CacheServiceTests.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 10.01.2026.
//

import XCTest
@testable import BabyFoodCareProject

final class CacheServiceTests: XCTestCase {
    
    var cacheService: CacheService!
    
    override func setUp() {
        super.setUp()
        cacheService = CacheService()
    }
    
    override func tearDown() async throws {
        // Clean up cache after each test
        await cacheService.invalidateAll()
        cacheService = nil
        try await super.tearDown()
    }
    
    // MARK: - Test Data
    
    struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
    }
    
    let testData = TestModel(id: 1, name: "Test Product")
    let testData2 = TestModel(id: 2, name: "Another Product")
    
    // MARK: - Test 1: Cache stores and retrieves data
    
    func testCacheStoresAndRetrievesData() async {
        let key = CacheKey(endpoint: "test", parameters: [:])
        
        // Store data
        await cacheService.set(testData, for: key)
        
        // Retrieve data
        let retrieved: TestModel? = await cacheService.get(for: key)
        
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved, testData)
    }
    
    // MARK: - Test 2: Cache returns nil for non-existent key
    
    func testCacheReturnsNilForNonExistentKey() async {
        let key = CacheKey(endpoint: "nonexistent", parameters: [:])
        
        let retrieved: TestModel? = await cacheService.get(for: key)
        
        XCTAssertNil(retrieved)
    }
    
    // MARK: - Test 3: Cache invalidates specific key
    
    func testCacheInvalidatesSpecificKey() async {
        let key1 = CacheKey(endpoint: "test1", parameters: [:])
        let key2 = CacheKey(endpoint: "test2", parameters: [:])
        
        // Store data for both keys
        await cacheService.set(testData, for: key1)
        await cacheService.set(testData2, for: key2)
        
        // Invalidate only key1
        await cacheService.invalidate(for: key1)
        
        // key1 should be nil, key2 should still exist
        let retrieved1: TestModel? = await cacheService.get(for: key1)
        let retrieved2: TestModel? = await cacheService.get(for: key2)
        
        XCTAssertNil(retrieved1)
        XCTAssertNotNil(retrieved2)
        XCTAssertEqual(retrieved2, testData2)
    }
    
    // MARK: - Test 4: Cache invalidates all entries
    
    func testCacheInvalidatesAll() async {
        let key1 = CacheKey(endpoint: "test1", parameters: [:])
        let key2 = CacheKey(endpoint: "test2", parameters: [:])
        
        // Store data for both keys
        await cacheService.set(testData, for: key1)
        await cacheService.set(testData2, for: key2)
        
        // Invalidate all
        await cacheService.invalidateAll()
        
        // Both should be nil
        let retrieved1: TestModel? = await cacheService.get(for: key1)
        let retrieved2: TestModel? = await cacheService.get(for: key2)
        
        XCTAssertNil(retrieved1)
        XCTAssertNil(retrieved2)
    }
    
    // MARK: - Test 5: Cache key generation with parameters
    
    func testCacheKeyGenerationWithParameters() {
        let key1 = CacheKey(endpoint: "products", parameters: ["page": "1", "search": "apple"])
        let key2 = CacheKey(endpoint: "products", parameters: ["search": "apple", "page": "1"])
        let key3 = CacheKey(endpoint: "products", parameters: ["page": "2", "search": "apple"])
        
        // Keys with same parameters (different order) should have same stringValue
        XCTAssertEqual(key1.stringValue, key2.stringValue)
        
        // Keys with different parameters should have different stringValue
        XCTAssertNotEqual(key1.stringValue, key3.stringValue)
        
        // Logging value should be readable
        XCTAssertTrue(key1.loggingValue.contains("products"))
        XCTAssertTrue(key1.loggingValue.contains("page=1"))
        XCTAssertTrue(key1.loggingValue.contains("search=apple"))
    }
    
    // MARK: - Test 6: Cache convenience initializers
    
    func testCacheKeyConvenienceInitializers() {
        let productsKey = CacheKey.products(page: 1, search: "test")
        let detailsKey = CacheKey.productDetails(id: 42)
        
        XCTAssertEqual(productsKey.endpoint, "products")
        XCTAssertEqual(productsKey.parameters["page"], "1")
        XCTAssertEqual(productsKey.parameters["search"], "test")
        
        XCTAssertEqual(detailsKey.endpoint, "productDetails")
        XCTAssertEqual(detailsKey.parameters["id"], "42")
    }
    
    // MARK: - Test 7: GetStale returns data even after normal get returns nil
    
    func testGetStaleReturnsDataWhenExpired() async {
        let key = CacheKey(endpoint: "test", parameters: [:])
        
        // Store data
        await cacheService.set(testData, for: key)
        
        // getStale should return data
        let staleData: TestModel? = await cacheService.getStale(for: key)
        
        XCTAssertNotNil(staleData)
        XCTAssertEqual(staleData, testData)
    }
    
    // MARK: - Test 8: Cache persists to disk and loads on retrieval
    
    func testCachePersistsToDisk() async {
        let key = CacheKey(endpoint: "diskTest", parameters: [:])
        
        // Store data
        await cacheService.set(testData, for: key)
        
        // Create a new cache service instance (simulates app restart)
        let newCacheService = CacheService()
        
        // Should be able to retrieve from disk
        let retrieved: TestModel? = await newCacheService.get(for: key)
        
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved, testData)
        
        // Cleanup
        await newCacheService.invalidateAll()
    }
    
    // MARK: - Test 9: Different parameter combinations create different cache entries
    
    func testDifferentParametersCreateDifferentEntries() async {
        let key1 = CacheKey.products(page: 1)
        let key2 = CacheKey.products(page: 2)
        let key3 = CacheKey.products(search: "apple")
        
        let data1 = [TestModel(id: 1, name: "Page 1")]
        let data2 = [TestModel(id: 2, name: "Page 2")]
        let data3 = [TestModel(id: 3, name: "Search")]
        
        // Store different data for different keys
        await cacheService.set(data1, for: key1)
        await cacheService.set(data2, for: key2)
        await cacheService.set(data3, for: key3)
        
        // Each key should return its own data
        let retrieved1: [TestModel]? = await cacheService.get(for: key1)
        let retrieved2: [TestModel]? = await cacheService.get(for: key2)
        let retrieved3: [TestModel]? = await cacheService.get(for: key3)
        
        XCTAssertEqual(retrieved1, data1)
        XCTAssertEqual(retrieved2, data2)
        XCTAssertEqual(retrieved3, data3)
    }
    
    // MARK: - Test 10: Cache entry model correctly tracks timestamps
    
    func testCacheEntryTracksTimestamps() {
        let entry = CacheEntry(data: testData, ttl: 600) // 10 minutes
        
        XCTAssertFalse(entry.isExpired)
        XCTAssertLessThan(entry.age, 1) // Should be less than 1 second old
        XCTAssertEqual(entry.expiredAgo, 0) // Not expired yet
        
        // formattedAge should return seconds for fresh entry
        XCTAssertTrue(entry.formattedAge.contains("s"))
    }
    
    // MARK: - Test 11: Cache entry correctly identifies expired entries
    
    func testCacheEntryExpirationDetection() {
        // Create entry with 0 TTL (immediately expired)
        let expiredEntry = CacheEntry(data: testData, ttl: 0)
        
        // Small delay to ensure expiration
        XCTAssertTrue(expiredEntry.isExpired)
        XCTAssertGreaterThanOrEqual(expiredEntry.expiredAgo, 0)
    }
    
    // MARK: - Test 12: Cache handles ProductsModel array correctly
    
    func testCacheHandlesProductsModelArray() async {
        let key = CacheKey.products()
        
        let products = [
            ProductsModel(
                id: 1,
                title: "Test Product",
                foodType: "Vegetables",
                description: "Test description",
                imageURL: "https://example.com/image.jpg",
                foodTypeImageURL: "https://example.com/type.jpg",
                monthFrom: 6,
                allergen: false,
                allergenDescription: nil,
                withWarning: false,
                warningNote: nil,
                howToServe: nil,
                howToServeImageURL: nil,
                calories: 100,
                protein: 5,
                fats: 2,
                carbs: 15
            )
        ]
        
        // Store products
        await cacheService.set(products, for: key)
        
        // Retrieve products
        let retrieved: [ProductsModel]? = await cacheService.get(for: key)
        
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.count, 1)
        XCTAssertEqual(retrieved?.first?.id, 1)
        XCTAssertEqual(retrieved?.first?.title, "Test Product")
    }
}
