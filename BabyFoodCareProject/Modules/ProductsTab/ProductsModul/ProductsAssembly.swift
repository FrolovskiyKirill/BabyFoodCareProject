//
//  ProductsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

class ProductsAssembly {
    
    static func makeModule(coordinator: ProductsCoordinator) -> UIViewController {
        
        @Injected var service: APIClient
        @Injected var imageService: APIImageClient
        let presenter = ProductsPresenter(apiClient: service, apiImageClient: imageService, coordinator: coordinator)
        let view = ProductsView()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
