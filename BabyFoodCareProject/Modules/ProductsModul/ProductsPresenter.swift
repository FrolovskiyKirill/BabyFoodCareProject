//
//  ProductsPresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

protocol IProductsPresenter: AnyObject {
    func viewDidLoad()
    func obtainedData(products: [ProductsModel])
}

class ProductsPresenter {
    weak var view: IProductsView?
    var interactor: IProductsInteractor
    var router: IProductsRouter
    
//    var authority: [Authority]?
    var products: [ProductsModel]?
    
    init(interactor: IProductsInteractor, router: IProductsRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ProductsPresenter: IProductsPresenter {
    
    func viewDidLoad() {
        interactor.getData()
    }
    
    func obtainedData(products: [ProductsModel]) {
        self.products = products
        view?.updateProducts(with: products)
    }
}
