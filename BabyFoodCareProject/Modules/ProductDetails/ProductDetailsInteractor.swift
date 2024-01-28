//
//  ProductDetailsInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

protocol IProductDetailsInteractor {
    
}

class ProductDetailsInteractor: IProductDetailsInteractor {
    weak var presenter: IProductDetailsPresentor?
    let APIClient: ProductsProtocol
    
    init(APIClient: APIClient) {
        self.APIClient = APIClient
    }
}
