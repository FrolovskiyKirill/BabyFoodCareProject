//
//  MockProductsCoordinator.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 27.12.2024.
//

import UIKit
@testable import BabyFoodCareProject

final class MockProductsCoordinator: ProductsCoordinator {
    var showDetailsCalled = false
    var lastProductId: Int?
    
    override func showDetails(for productId: Int) {
        showDetailsCalled = true
        lastProductId = productId
    }
    
    override func start() {
        // Mock implementation - do nothing
    }
    
    override func finish() {
        // Mock implementation - do nothing
    }
}
