//
//  MockAPIClient.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 16.03.2024.
//

import Foundation
@testable import BabyFoodCareProject

final class MockAPIClient: ProductsProtocol, Mockable {
    
    let fileName: String?
    
    init(fileName: String?) {
        self.fileName = fileName
    }
    
    func getProducts() async throws -> [BabyFoodCareProject.ProductsModel] {
        guard let fileName else { return [] }
        
        return loadJSON(filename: fileName, type: ProductsModel.self)
    }
}
