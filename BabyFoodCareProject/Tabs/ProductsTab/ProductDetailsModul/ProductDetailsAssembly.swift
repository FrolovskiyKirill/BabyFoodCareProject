//
//  ProductDetailsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import UIKit

final class ProductDetailsAssembly {
    static func makeModule(coordinator: ProductDetailsCoordinator, productId: Int) -> UIViewController {
        let APIClient = APIClient()
        let interactor = ProductDetailsInteractor(APIClient: APIClient, productId: productId)
        let presenter = ProductDetailsPresenter(interactor: interactor, coordinator: coordinator, productId: productId)
        let view = ProductDetailsView()
        interactor.presenter = presenter
        view.presenter = presenter
        presenter.view = view
        print("?????\(productId)")
        return view
    }
}

