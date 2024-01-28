//
//  APIRouter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

enum APIRouter {
    case getAuthorities
    case getRatings
    case getEstablishments(authorityId: Int)
    case getProducts
    
    var host: String {
        switch self {
        case .getAuthorities, .getRatings, .getEstablishments:
            return "api.ratings.food.gov.uk"
        case .getProducts:
            return "davnopora.fun"
        }
    }
    
    var scheme: String {
        switch self {
        case .getAuthorities, .getRatings, .getEstablishments, .getProducts:
            return "https"
        }
    }
    
    var path: String {
        switch self {
        case .getAuthorities:
            return "/authorities/basic"
        case .getRatings:
            return "/ratings"
        case .getEstablishments:
            return "/establishments"
        case .getProducts:
            return "/kir/food"
        }
    }
    
    var method: String {
        switch self {
        case .getAuthorities, .getRatings, .getEstablishments, .getProducts:
            return "GET"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getAuthorities, .getRatings, .getProducts:
            return []
        case .getEstablishments(let authorityId):
            return [URLQueryItem(name: "localAuthorityId", value: "\(authorityId)")]
        }
    }
}


