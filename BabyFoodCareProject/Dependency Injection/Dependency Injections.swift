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
    let container = Container()
    
    init() {
        container.register(APIClient.self) { _ in APIClient() }
        container.register(APIImageClient.self) { _ in APIImageClient() }
        container.register(ToastServiceProtocol.self) { _ in ToastService() }.inObjectScope(.container)
        container.register(CacheServiceProtocol.self) { _ in CacheService() }.inObjectScope(.container)
    }
    
}

@propertyWrapper struct Injected<Dependency> {
    let wrappedValue: Dependency
    
    init() {
        guard let resolved = Injections.shared.container.resolve(Dependency.self) else {
            fatalError("Dependency \(Dependency.self) is not registered in the container")
        }
        self.wrappedValue = resolved
    }
}
