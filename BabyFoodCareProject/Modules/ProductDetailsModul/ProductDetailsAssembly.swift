//
//  ProductDetailsAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import UIKit

class ProductDetailsAssembly {
    static func makeModule() -> UIViewController {
        let APIClient = APIClient()
        let router = ProductDetailsRouter()
        let interactor = ProductDetailsInteractor(APIClient: APIClient)
        let presenter = ProductDetailsPresenter(interactor: interactor, router: router)
        let view = ProductDetailsView()
        router.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
