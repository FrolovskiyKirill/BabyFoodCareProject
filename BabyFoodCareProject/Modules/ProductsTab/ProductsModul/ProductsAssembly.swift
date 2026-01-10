//
//  ProductsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

@MainActor
final class ProductsAssembly {
    static func makeModule(coordinator: ProductsCoordinator) -> UIViewController {
        
        @Injected var service: APIClient
        @Injected var imageService: APIImageClient
        @Injected var toastService: ToastServiceProtocol
        @Injected var cacheService: CacheServiceProtocol
        
        let presenter = ProductsPresenter(
            apiClient: service,
            apiImageClient: imageService,
            coordinator: coordinator,
            toastService: toastService,
            cacheService: cacheService
        )
        let view = ProductsView()
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
