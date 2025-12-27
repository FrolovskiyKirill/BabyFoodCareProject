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
        let presenter = FavoritePresenter(router: router)
        let view = FavoriteView()
        router.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
