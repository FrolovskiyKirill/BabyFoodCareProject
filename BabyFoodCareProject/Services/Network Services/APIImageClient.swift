//
//  APIClientImage.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 03.03.2024.
//

import Foundation

protocol ImageProtocol {
    func fetchImage(urlString: String) async throws -> Data
}

final class APIImageClient: ImageProtocol {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        let cache = URLCache(memoryCapacity: 100 * 1024 * 1024, diskCapacity: 500 * 1024 * 1024, diskPath: nil)
        configuration.urlCache = cache
        self.session = URLSession(configuration: configuration)
    }
    
    func fetchImage(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw APIRequestError.badUrl }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        return try await withCheckedThrowingContinuation { continuation in
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    return continuation.resume(with: .failure(error))
                }
                
                guard let data = data, let response = response else {
                    return continuation.resume(with: .failure(APIRequestError.noData))
                }
                
                let cachedData = CachedURLResponse(response: response, data: data)
                self.session.configuration.urlCache?.storeCachedResponse(cachedData, for: request)
                
                continuation.resume(with: .success(data))
            }
            dataTask.resume()
        }
    }
}
