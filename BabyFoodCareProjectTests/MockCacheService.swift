//
//  MockCacheService.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 10.01.2026.
//

import Foundation
@testable import BabyFoodCareProject

/// Mock implementation of CacheServiceProtocol for testing
actor MockCacheService: CacheServiceProtocol {
    
    // MARK: - Tracking Properties
    
    var getCalled = false
    var getStaleCalled = false
    var setCalled = false
    var invalidateCalled = false
    var invalidateAllCalled = false
    
    var lastGetKey: CacheKey?
    var lastSetKey: CacheKey?
    var lastInvalidateKey: CacheKey?
    
    var getCallCount = 0
    var setCallCount = 0
    
    // MARK: - Mock Data Storage
    
    private var storage: [CacheKey: Any] = [:]
    private var staleStorage: [CacheKey: Any] = [:]
    
    // MARK: - Configuration
    
    /// When true, get() returns nil to simulate cache miss
    var shouldReturnNil = false
    
    /// When true, getStale() returns data from staleStorage
    var shouldReturnStale = false
    
    // MARK: - CacheServiceProtocol
    
    func get<T: Codable>(for key: CacheKey) async -> T? {
        getCalled = true
        lastGetKey = key
        getCallCount += 1
        
        if shouldReturnNil {
            return nil
        }
        
        return storage[key] as? T
    }
    
    func getStale<T: Codable>(for key: CacheKey) async -> T? {
        getStaleCalled = true
        lastGetKey = key
        
        if shouldReturnStale {
            return staleStorage[key] as? T
        }
        
        return storage[key] as? T
    }
    
    func set<T: Codable>(_ value: T, for key: CacheKey) async {
        setCalled = true
        lastSetKey = key
        setCallCount += 1
        storage[key] = value
    }
    
    func invalidate(for key: CacheKey) async {
        invalidateCalled = true
        lastInvalidateKey = key
        storage.removeValue(forKey: key)
        staleStorage.removeValue(forKey: key)
    }
    
    func invalidateAll() async {
        invalidateAllCalled = true
        storage.removeAll()
        staleStorage.removeAll()
    }
    
    // MARK: - Test Helpers
    
    /// Pre-populates cache with test data
    func preloadData<T: Codable>(_ data: T, for key: CacheKey) {
        storage[key] = data
    }
    
    /// Pre-populates stale cache with test data
    func preloadStaleData<T: Codable>(_ data: T, for key: CacheKey) {
        staleStorage[key] = data
    }
    
    /// Resets all tracking properties
    func reset() {
        getCalled = false
        getStaleCalled = false
        setCalled = false
        invalidateCalled = false
        invalidateAllCalled = false
        lastGetKey = nil
        lastSetKey = nil
        lastInvalidateKey = nil
        getCallCount = 0
        setCallCount = 0
        shouldReturnNil = false
        shouldReturnStale = false
        storage.removeAll()
        staleStorage.removeAll()
    }
}
