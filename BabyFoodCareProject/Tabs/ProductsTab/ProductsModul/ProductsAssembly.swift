//
//  ProductsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

class ProductsAssembly {
    
    static func makeModule(coordinator: ProductsCoordinator) -> UIViewController {
        let service = Injections.shared.apiClient
        let imageService = Injections.shared.apiImageClient
        let interactor = ProductsInteractor(APIClient: service, APIImageClient: imageService)
        let presenter = ProductsPresenter(interactor: interactor, coordinator: coordinator)
        let view = ProductsView()
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
