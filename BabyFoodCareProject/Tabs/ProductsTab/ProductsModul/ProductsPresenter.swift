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
    func didSelectProduct(with productId: Int)
}

protocol ProductsPresenterOutput: AnyObject { }

final class ProductsPresenter {
    weak var view: ProductsViewOutput?
    var interactor: ProductsInteractorInput
    var coordinator: ProductsCoordinator
    
    var products: [ProductsModel]?
    
    init(interactor: ProductsInteractorInput, coordinator: ProductsCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
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
    func didSelectProduct(with productId: Int) {
        coordinator.showDetails(for: productId)
    }
}
