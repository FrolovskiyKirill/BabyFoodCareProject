//
//  CacheKey.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 10.01.2026.
//

import Foundation

/// Represents a unique key for caching based on endpoint and parameters
struct CacheKey: Hashable, Codable {
    /// The API endpoint (e.g., "products", "productDetails")
    let endpoint: String
    /// Query parameters (pagination, search, filters)
    let parameters: [String: String]
    
    /// Creates a string representation suitable for file names
    var stringValue: String {
        var components = [endpoint]
        
        // Sort parameters for consistent key generation
        let sortedParams = parameters.sorted { $0.key < $1.key }
        for (key, value) in sortedParams {
            components.append("\(key)=\(value)")
        }
        
        let joined = components.joined(separator: "_")
        // Replace characters that are invalid in file names
        return joined
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: " ", with: "_")
    }
    
    /// Creates a human-readable string for logging
    var loggingValue: String {
        if parameters.isEmpty {
            return endpoint
        }
        
        let sortedParams = parameters.sorted { $0.key < $1.key }
        let paramString = sortedParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return "\(endpoint)?\(paramString)"
    }
    
    init(endpoint: String, parameters: [String: String] = [:]) {
        self.endpoint = endpoint
        self.parameters = parameters
    }
}

// MARK: - Convenience initializers for common use cases
extension CacheKey {
    /// Creates a cache key for products list
    static func products(page: Int? = nil, search: String? = nil) -> CacheKey {
        var params: [String: String] = [:]
        if let page = page {
            params["page"] = String(page)
        }
        if let search = search, !search.isEmpty {
            params["search"] = search
        }
        return CacheKey(endpoint: "products", parameters: params)
    }
    
    /// Creates a cache key for product details
    static func productDetails(id: Int) -> CacheKey {
        CacheKey(endpoint: "productDetails", parameters: ["id": String(id)])
    }
}
