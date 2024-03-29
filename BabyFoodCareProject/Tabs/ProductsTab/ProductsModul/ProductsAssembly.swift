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
        let interactor = ProductsInteractor(APIClient: service, apiImageClient: imageService)
        let presenter = ProductsPresenter(interactor: interactor, coordinator: coordinator)
        let view = ProductsView()
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
