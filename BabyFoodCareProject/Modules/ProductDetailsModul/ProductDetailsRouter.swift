//
//  ProductDetailsRouter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

protocol IProductDetailsRouter {
    
}

class ProductDetailsRouter: IProductDetailsRouter {
    weak var presenter: IProductDetailsPresentor?
}
