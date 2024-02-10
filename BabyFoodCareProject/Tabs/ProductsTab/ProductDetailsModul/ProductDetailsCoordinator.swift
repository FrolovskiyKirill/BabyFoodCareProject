//
//  ProductDetailsCoordinator.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 05.02.2024.
//

import Foundation

class ProductDetailsCoordinator: Coordinator {
    
    var productId: Int?
    
    override func start() {
        
        guard let productId = productId else {
            print("Product ID is not set")
            return
        }
        
        let productDetailsView = ProductDetailsAssembly.makeModule(coordinator: self, productId: productId)
        navigationController?.pushViewController(productDetailsView, animated: true)
    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
}
