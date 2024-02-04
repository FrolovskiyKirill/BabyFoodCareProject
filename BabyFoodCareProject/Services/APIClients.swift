//
//  API Clients.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

protocol ProductsProtocol {
    func getProducts() async throws -> [ProductsModel]
}

protocol ProductDetailsProtocol {
    func getProductDetails(poductID: Int) async throws -> ProductDetailsModel
}

final class APIClient: ProductsProtocol {
    func getProducts() async throws -> [ProductsModel] {
        let products: [ProductsModel] = try await APIRequestDispatcher.request(apiRouter: .getProducts)
        return products
    }
}

extension APIClient: ProductDetailsProtocol {
    func getProductDetails(poductID: Int) async throws -> ProductDetailsModel {
        let productDetails: ProductDetailsModel = try await APIRequestDispatcher.request(apiRouter: .getProductDetails(poductID: poductID))
        return productDetails
    }
}


