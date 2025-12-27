//
//  ProductDetailsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import UIKit

final class ProductDetailsAssembly {
    static func makeModule(coordinator: ProductDetailsCoordinator, productId: Int) -> UIViewController {
        @Injected var service: APIClient
        let presenter = ProductDetailsPresenter(apiClient: service, coordinator: coordinator, productId: productId)
        let view = ProductDetailsView()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
