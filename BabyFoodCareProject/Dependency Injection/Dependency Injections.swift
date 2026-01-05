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
        container.register(ToastServiceProtocol.self) { _ in
            MainActor.assumeIsolated {
                ToastService()
            }
        }
    }
    
    var apiClient: APIClient { container.resolve(APIClient.self) ?? APIClient() }
    var apiImageClient: APIImageClient { container.resolve(APIImageClient.self) ?? APIImageClient() }
}

@propertyWrapper struct Injected<Dependency> {
  let wrappedValue: Dependency
 
  init() {
    self.wrappedValue = Injections.shared.container.resolve(Dependency.self)!
  }
}
