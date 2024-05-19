//
//  FavoriteAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

final class FavoriteAssembly {
    static func makeModule() -> UIViewController {
        let router = FavoriteRouter()
        let interactor = FavoriteInteractor()
        let presenter = FavoritePresenter(interactor: interactor, router: router)
        let view = FavoriteView()
        router.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
