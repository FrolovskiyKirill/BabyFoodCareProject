//
//  ProductsTests.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 16.03.2024.
//

import XCTest
@testable import BabyFoodCareProject

final class ProductsTests: XCTestCase {
    
    var productsInteractor: ProductsInteractor!
    var mockApiClient: ProductsProtocol!
    
    override func setUp() {
        super.setUp()
    }
    
    let productModelMock = ProductsModel(id: 8, title: "Test Pepper", foodType: "Vegetables", description: "123", imageURL: "123", foodTypeImageURL: "123", monthFrom: 6, allergen: true, allergenDescription: nil, withWarning: true, warningNote: nil, howToServe: nil, howToServeImageURL: nil, calories: 0, protein: 0, fats: 0, carbs: 0)
    
    func testInteractorGetProducts() async throws {
        mockApiClient = MockAPIClient(fileName: "FoodResponseOne")
        productsInteractor = ProductsInteractor(APIClient: mockApiClient, apiImageClient: APIImageClient())

        let products = try await mockApiClient.getProducts()
        
        XCTAssertEqual(products.first?.id, productModelMock.id)
    }

    override func tearDown() {
        super.tearDown()
    }

}
