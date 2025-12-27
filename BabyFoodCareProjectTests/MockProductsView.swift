//
//  MockProductsView.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 27.12.2024.
//

import XCTest
@testable import BabyFoodCareProject

final class MockProductsView: ProductsViewOutput {
    var setupInitialStateCalled = false
    var applySnapshotCalled = false
    var applySnapshotCallCount = 0
    var lastSnapshot: [ProductsModel] = []
    var lastAnimatingDifferences: Bool = false
    
    func viewDidLoad() {
        // Not used in tests
    }
    
    func setupInitialState() {
        setupInitialStateCalled = true
    }
    
    func applySnapshot(model: [ProductsModel], animatingDifferences: Bool) {
        applySnapshotCalled = true
        applySnapshotCallCount += 1
        lastSnapshot = model
        lastAnimatingDifferences = animatingDifferences
    }
    
    func didSelectProduct(with id: Int) {
        // Not used in tests
    }
}
