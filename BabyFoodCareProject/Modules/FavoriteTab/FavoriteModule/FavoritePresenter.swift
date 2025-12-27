//
//  FavoritePresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import Foundation

protocol FavoritePresenterInput: AnyObject {
    func viewDidLoad()
}

protocol FavoritePresenterOutput: AnyObject {
}

final class FavoritePresenter {
    weak var view: FavoriteViewOutput?
    var router: FavoriteRouterProtocol
    
    init(router: FavoriteRouterProtocol) {
        self.router = router
    }
}

extension FavoritePresenter: FavoritePresenterInput {
    func viewDidLoad() {
        print("!!!!!HELLLOO")
    }
}

extension FavoritePresenter: FavoritePresenterOutput {

}
