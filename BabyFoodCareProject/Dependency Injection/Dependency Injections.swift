//
//  Dependency Injection.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 01.03.2024.
//

import Foundation
import Swinject

final class Injections {
    
    static let shared = Injections()
    
    private let container = Container()
    
    init() {
        container.register(APIClient.self) { _ in APIClient() }
    }
    
    var apiClient: APIClient {
        container.resolve(APIClient.self) ?? APIClient()
    }
    
    var apiImageClient: APIImageClient {
        container.resolve(APIImageClient.self) ?? APIImageClient()
    }
}
