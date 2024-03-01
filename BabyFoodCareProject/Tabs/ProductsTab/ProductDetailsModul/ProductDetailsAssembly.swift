//
//  ProductDetailsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import UIKit

final class ProductDetailsAssembly {
    static func makeModule(coordinator: ProductDetailsCoordinator, productId: Int) -> UIViewController {
        let service = Injections.shared.apiClient
        let interactor = ProductDetailsInteractor(APIClient: service)
        let presenter = ProductDetailsPresenter(interactor: interactor, coordinator: coordinator, productId: productId)
        let view = ProductDetailsView()
        interactor.presenter = presenter
        view.presenter = presenter
        presenter.view = view
        return view
    }
}

