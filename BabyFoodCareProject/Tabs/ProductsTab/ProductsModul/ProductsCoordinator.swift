//
//  ProductsCoordinator.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

class ProductsCoordinator: Coordinator {
    
    override func start() {
        let productsView = ProductsAssembly.makeModule(coordinator: self)
        navigationController?.pushViewController(productsView, animated: true)
    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
    
    func showDetails() {
        let productsCoordinator = ProductDetailsCoordinator(type: .productDetails, navigationController: navigationController ?? UINavigationController())
        productsCoordinator.start()
    }
}
