//
//  API Clients.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

protocol AuthorityProtocol {
    func getAuthorities() async throws -> [Authority]
}

protocol RatingProtocol {
    func getRatings(schemeTypeId: Int) async throws -> [Rating]
}

protocol EstablishmentProtocol {
    func getEstablishments(authorityId: Int) async throws -> [Establishment]
}

protocol ProductsProtocol {
    func getProducts() async throws -> [ProductsModel]
}

class APIClient: AuthorityProtocol {
    func getAuthorities() async throws -> [Authority] {
        let response: AuthoritiesResponse = try await APIRequestDispatcher.request(apiRouter: .getAuthorities)
        return response.authorities
    }
}

extension APIClient: RatingProtocol {
    func getRatings(schemeTypeId: Int) async throws -> [Rating] {
        let response: RatingsResponse = try await APIRequestDispatcher.request(apiRouter: .getRatings)
        return response.ratings.filter({ $0.schemeId == schemeTypeId })
    }
}

extension APIClient: EstablishmentProtocol {
    func getEstablishments(authorityId: Int) async throws -> [Establishment] {
        let response: EstablishmentResponse = try await APIRequestDispatcher.request(apiRouter: .getEstablishments(authorityId: authorityId))
        return response.establishments
    }
}

extension APIClient: ProductsProtocol {
    func getProducts() async throws -> [ProductsModel] {
        // Попытка отправить запрос и получить ответ
        let products: [ProductsModel] = try await APIRequestDispatcher.request(apiRouter: .getProducts)
        // Возвращение полученных продуктов
        return products
    }
}


