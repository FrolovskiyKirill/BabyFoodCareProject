//
//  ProductsPresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

protocol ProductsPresenterInput: AnyObject {
    func viewDidLoad()
    func obtainedData(products: [ProductsModel])
    func didSelectProduct(with productId: Int)
    func fetchProductImage(for product: ProductsModel, cell: ProductsCell)
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
    
    func fetchProductImage(for product: ProductsModel, cell: ProductsCell) {
        interactor.fetchImageData(urlString: product.imageURL) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.updateImage(image)
                }
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error)")
                // Обработка ошибки, возможно установка изображения по умолчанию
            }
        }
    }
}

extension ProductsPresenter: ProductsPresenterOutput {
    func didSelectProduct(with productId: Int) {
        coordinator.showDetails(for: productId)
    }
}
