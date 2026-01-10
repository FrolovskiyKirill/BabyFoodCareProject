//
//  CacheService.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 10.01.2026.
//

import Foundation

// MARK: - CacheServiceProtocol

protocol CacheServiceProtocol: Sendable {
    /// Retrieves cached data for the given key
    /// - Parameter key: The cache key
    /// - Returns: Cached data if available and not expired, nil otherwise
    func get<T: Codable>(for key: CacheKey) async -> T?
    
    /// Retrieves cached data even if expired (for fallback scenarios)
    /// - Parameter key: The cache key
    /// - Returns: Cached data if available (even if expired), nil otherwise
    func getStale<T: Codable>(for key: CacheKey) async -> T?
    
    /// Stores data in the cache
    /// - Parameters:
    ///   - value: The data to cache
    ///   - key: The cache key
    func set<T: Codable>(_ value: T, for key: CacheKey) async
    
    /// Invalidates cache for a specific key
    /// - Parameter key: The cache key to invalidate
    func invalidate(for key: CacheKey) async
    
    /// Invalidates all cache entries
    func invalidateAll() async
}

// MARK: - CacheService

actor CacheService: CacheServiceProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let ttl: TimeInterval = 10 * 60 // 10 minutes
        static let maxEntries: Int = 150
        static let cacheDirectoryName = "ResponseCache"
    }
    
    // MARK: - Properties
    
    /// In-memory cache storage with type-erased entries
    private var memoryCache: [CacheKey: Any] = [:]
    
    /// Tracks access order for LRU eviction
    private var accessOrder: [CacheKey] = []
    
    /// File manager for disk operations
    private let fileManager = FileManager.default
    
    /// Cache directory URL
    private lazy var cacheDirectory: URL? = {
        guard let cachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            log("ERROR: Could not find caches directory")
            return nil
        }
        let cacheDir = cachesDirectory.appendingPathComponent(Constants.cacheDirectoryName)
        
        if !fileManager.fileExists(atPath: cacheDir.path) {
            do {
                try fileManager.createDirectory(at: cacheDir, withIntermediateDirectories: true)
            } catch {
                log("ERROR: Could not create cache directory: \(error)")
                return nil
            }
        }
        return cacheDir
    }()
    
    // MARK: - Initialization
    
    init() {
        log("Initialized")
    }
    
    // MARK: - CacheServiceProtocol
    
    func get<T: Codable>(for key: CacheKey) async -> T? {
        // First, try memory cache
        if let entry = memoryCache[key] as? CacheEntry<T> {
            if !entry.isExpired {
                updateAccessOrder(for: key)
                log("HIT: \(key.loggingValue) (age: \(entry.formattedAge))")
                return entry.data
            } else {
                log("EXPIRED: \(key.loggingValue) (expired \(entry.formattedExpiredAgo) ago)")
                // Don't remove - might be needed for stale fallback
            }
        }
        
        // Try disk cache
        if let entry: CacheEntry<T> = loadFromDisk(for: key) {
            if !entry.isExpired {
                // Restore to memory cache
                memoryCache[key] = entry
                updateAccessOrder(for: key)
                log("HIT (disk): \(key.loggingValue) (age: \(entry.formattedAge))")
                return entry.data
            } else {
                // Store in memory for potential stale fallback
                memoryCache[key] = entry
                log("EXPIRED (disk): \(key.loggingValue) (expired \(entry.formattedExpiredAgo) ago)")
            }
        }
        
        log("MISS: \(key.loggingValue)")
        return nil
    }
    
    func getStale<T: Codable>(for key: CacheKey) async -> T? {
        // Check memory cache first (including expired entries)
        if let entry = memoryCache[key] as? CacheEntry<T> {
            if entry.isExpired {
                log("STALE: \(key.loggingValue) (expired \(entry.formattedExpiredAgo) ago, serving due to network error)")
            } else {
                log("HIT: \(key.loggingValue) (age: \(entry.formattedAge))")
            }
            updateAccessOrder(for: key)
            return entry.data
        }
        
        // Try disk cache
        if let entry: CacheEntry<T> = loadFromDisk(for: key) {
            memoryCache[key] = entry
            updateAccessOrder(for: key)
            if entry.isExpired {
                log("STALE (disk): \(key.loggingValue) (expired \(entry.formattedExpiredAgo) ago, serving due to network error)")
            } else {
                log("HIT (disk): \(key.loggingValue) (age: \(entry.formattedAge))")
            }
            return entry.data
        }
        
        log("MISS (no stale data): \(key.loggingValue)")
        return nil
    }
    
    func set<T: Codable>(_ value: T, for key: CacheKey) async {
        let entry = CacheEntry(data: value, ttl: Constants.ttl)
        
        // Check if we need to evict entries
        if memoryCache[key] == nil && memoryCache.count >= Constants.maxEntries {
            evictLRU()
        }
        
        // Store in memory
        memoryCache[key] = entry
        updateAccessOrder(for: key)
        
        // Persist to disk
        saveToDisk(entry, for: key)
        
        log("SET: \(key.loggingValue)")
    }
    
    func invalidate(for key: CacheKey) async {
        memoryCache.removeValue(forKey: key)
        accessOrder.removeAll { $0 == key }
        removeFromDisk(for: key)
        log("INVALIDATE: \(key.loggingValue)")
    }
    
    func invalidateAll() async {
        memoryCache.removeAll()
        accessOrder.removeAll()
        clearDiskCache()
        log("INVALIDATE ALL")
    }
    
    // MARK: - LRU Management
    
    private func updateAccessOrder(for key: CacheKey) {
        accessOrder.removeAll { $0 == key }
        accessOrder.append(key)
    }
    
    private func evictLRU() {
        guard let lruKey = accessOrder.first else { return }
        
        memoryCache.removeValue(forKey: lruKey)
        accessOrder.removeFirst()
        removeFromDisk(for: lruKey)
        
        log("EVICT (LRU): \(lruKey.loggingValue)")
    }
    
    // MARK: - Disk Operations
    
    private func fileURL(for key: CacheKey) -> URL? {
        cacheDirectory?.appendingPathComponent("\(key.stringValue).json")
    }
    
    private func saveToDisk<T: Codable>(_ entry: CacheEntry<T>, for key: CacheKey) {
        guard let url = fileURL(for: key) else { return }
        
        do {
            let data = try JSONEncoder().encode(entry)
            try data.write(to: url, options: .atomic)
        } catch {
            log("ERROR: Failed to save to disk for \(key.loggingValue): \(error)")
        }
    }
    
    private func loadFromDisk<T: Codable>(for key: CacheKey) -> CacheEntry<T>? {
        guard let url = fileURL(for: key),
              fileManager.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let entry = try JSONDecoder().decode(CacheEntry<T>.self, from: data)
            return entry
        } catch {
            log("ERROR: Failed to load from disk for \(key.loggingValue): \(error)")
            // Remove corrupted file
            try? fileManager.removeItem(at: url)
            return nil
        }
    }
    
    private func removeFromDisk(for key: CacheKey) {
        guard let url = fileURL(for: key) else { return }
        try? fileManager.removeItem(at: url)
    }
    
    private func clearDiskCache() {
        guard let cacheDir = cacheDirectory else { return }
        
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
            log("ERROR: Failed to clear disk cache: \(error)")
        }
    }
    
    // MARK: - Logging
    
    private func log(_ message: String) {
        print("[CacheService] \(message)")
    }
}
