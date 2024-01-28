//
//  ProductsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

class ProductsAssembly {
    static func makeModule() -> UIViewController {
        let APIClient = APIClient()
        let router = ProductsRouter()
        let interactor = ProductsInteractor(APIClient: APIClient)
        let presenter = ProductsPresenter(interactor: interactor, router: router)
        let view = ProductsView()
        router.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
