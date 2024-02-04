//
//  ProductDetailsPresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

protocol ProductDetailsPresenterInput: AnyObject { 
    func viewDidLoad()
}

protocol ProductDetailsPresenterOutput: AnyObject {
}

final class ProductDetailsPresenter {
    weak var view: ProductDetailsViewOutput?
    var interactor: ProductDetailsInteractorInput
    var router: IProductDetailsRouter
    
    init(interactor: ProductDetailsInteractorInput, router: IProductDetailsRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ProductDetailsPresenter: ProductDetailsPresenterInput {
    func viewDidLoad() {
        interactor.getData()
        print("!!!!!HELLLOO")
    }
}

extension ProductDetailsPresenter: ProductDetailsPresenterOutput {
}
