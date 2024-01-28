//
//  ProductsRouter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

protocol IProductsRouter {
    
}

class ProductsRouter: IProductsRouter {
    weak var presenter: IProductsPresenter?
}
