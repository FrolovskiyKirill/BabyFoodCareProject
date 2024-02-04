//
//  ProductsPresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

protocol ProductsPresenterInput: AnyObject {
    func viewDidLoad()
    func obtainedData(products: [ProductsModel])
}

protocol ProductsPresenterOutput: AnyObject {


}

final class ProductsPresenter {
    weak var view: ProductsViewOutput?
    var interactor: ProductsInteractorInput
    var router: IProductsRouter
    
    var products: [ProductsModel]?
    
    init(interactor: ProductsInteractorInput, router: IProductsRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ProductsPresenter: ProductsPresenterInput { 
    func viewDidLoad() {
        interactor.getData()
    }
    
    func obtainedData(products: [ProductsModel]) {
        self.products = products
        view?.updateProducts(with: products)
    }
}

extension ProductsPresenter: ProductsPresenterOutput {
    

}