//
//  ProductDetailsCoordinator.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 05.02.2024.
//

import Foundation

class ProductDetailsCoordinator: Coordinator {
    override func start() {
        let productDetailsView = ProductDetailsAssembly.makeModule()
        navigationController?.pushViewController(productDetailsView, animated: true)
    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
}
