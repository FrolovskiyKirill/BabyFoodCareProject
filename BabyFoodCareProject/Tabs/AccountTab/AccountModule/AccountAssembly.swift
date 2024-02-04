//
//  AccountAssembly.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

final class AccountAssembly {
    static func makeModule() -> UIViewController {
        let router = AccountRouter()
        let interactor = AccountInteractor()
        let presenter = AccountPresenter(interactor: interactor, router: router)
        let view = AccountView()
        router.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        view.presenter = presenter
        return view
    }
}
