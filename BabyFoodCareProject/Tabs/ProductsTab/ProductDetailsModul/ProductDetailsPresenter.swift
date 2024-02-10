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
    var coordinator: ProductDetailsCoordinator
    let productId: Int
    
    init(interactor: ProductDetailsInteractorInput, coordinator: ProductDetailsCoordinator, productId: Int) {
        self.interactor = interactor
        self.coordinator = coordinator
        self.productId = productId
    }
}

extension ProductDetailsPresenter: ProductDetailsPresenterInput {
    func viewDidLoad() {
        interactor.getData()
        print("Product ID: \(productId)")
    }
}

extension ProductDetailsPresenter: ProductDetailsPresenterOutput {
}
