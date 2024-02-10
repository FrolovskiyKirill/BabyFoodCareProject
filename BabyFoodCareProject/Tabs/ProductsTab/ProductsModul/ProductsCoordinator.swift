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
    
    func showDetails(for productId: Int) {
        let productDetailsCoordinator = ProductDetailsCoordinator(type: .productDetails, navigationController: navigationController ?? UINavigationController())
        print(String(productId) + "!!SD!!")
        // Здесь вы можете передать productId в productDetailsCoordinator если это необходимо
        productDetailsCoordinator.productId = productId
        productDetailsCoordinator.start()
    }
}
