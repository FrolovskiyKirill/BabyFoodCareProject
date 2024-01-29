//
//  ProductDetailsPresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

protocol IProductDetailsPresentor: AnyObject {
    func viewDidLoad()
}

class ProductDetailsPresenter {
    weak var view: IProductDetailsView?
    var interactor: IProductDetailsInteractor
    var router: IProductDetailsRouter
    
    init(interactor: IProductDetailsInteractor, router: IProductDetailsRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ProductDetailsPresenter: IProductDetailsPresentor {
    func viewDidLoad() {
        interactor.getData()
    }
}
