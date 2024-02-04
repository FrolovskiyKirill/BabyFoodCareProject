//
//  APIRouter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//
// https://betterprogramming.pub/build-an-api-layer-in-swift-with-async-await-abe8a5ca75da where network layer from

import Foundation

enum APIRouter {
    case getProducts
    case getProductDetails(poductID: Int)
    
    var host: String {
        switch self {
        case .getProducts, .getProductDetails:
            return "davnopora.fun"
        }
    }
    
    var scheme: String {
        switch self {
        case .getProducts, .getProductDetails:
            return "https"
        }
    }
    
    var path: String {
        switch self {
        case .getProducts:
            return "/kir/food"
        case .getProductDetails(let poductID):
            return "/kir/food/\(poductID)"
        }
    }
    
    var method: String {
        switch self {
        case .getProducts, .getProductDetails:
            return "GET"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getProducts, .getProductDetails:
            return []
        }
    }
}


