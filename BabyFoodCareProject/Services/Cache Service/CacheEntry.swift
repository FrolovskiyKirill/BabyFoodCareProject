//
//  CacheEntry.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 10.01.2026.
//

import Foundation

/// Represents a cached data entry with metadata for expiration and LRU tracking
struct CacheEntry<T: Codable>: Codable {
    /// The cached data
    let data: T
    /// Timestamp when the entry was created
    let createdAt: Date
    /// Timestamp when the entry expires (TTL)
    let expiresAt: Date
    /// Last access timestamp for LRU eviction
    var lastAccessedAt: Date
    
    /// Checks if the entry has expired based on TTL
    var isExpired: Bool {
        Date() > expiresAt
    }
    
    /// Returns the age of the entry since creation
    var age: TimeInterval {
        Date().timeIntervalSince(createdAt)
    }
    
    /// Returns formatted age string for logging (e.g., "2m 30s")
    var formattedAge: String {
        let totalSeconds = Int(age)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    /// Returns how long ago the entry expired (for stale cache logging)
    var expiredAgo: TimeInterval {
        guard isExpired else { return 0 }
        return Date().timeIntervalSince(expiresAt)
    }
    
    /// Returns formatted expired ago string for logging
    var formattedExpiredAgo: String {
        let totalSeconds = Int(expiredAgo)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    init(data: T, ttl: TimeInterval) {
        let now = Date()
        self.data = data
        self.createdAt = now
        self.expiresAt = now.addingTimeInterval(ttl)
        self.lastAccessedAt = now
    }
}
