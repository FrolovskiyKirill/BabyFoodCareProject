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
    func fetchProductImage(for product: ProductsModel, cell: ProductCell)
}

protocol ProductsPresenterOutput: AnyObject { 
    func didSelectProduct(with productId: Int)
}

final class ProductsPresenter {
    
    //MARK: Properties
    weak var view: ProductsViewOutput?
    var interactor: ProductsInteractorInput
    var coordinator: ProductsCoordinator
    
    private var products: [ProductsModel] = []
    
    init(interactor: ProductsInteractorInput, coordinator: ProductsCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
}

// MARK: ProductsPresenter: ProductsPresenterInput
extension ProductsPresenter: ProductsPresenterInput {
    func viewDidLoad() {
        interactor.getData()
        view?.setupInitialState()
        view?.applySnapshot(model: products, animatingDifferences: true)
    }
    
    func obtainedData(products: [ProductsModel]) {
        self.products = products
        DispatchQueue.main.async {
            self.view?.applySnapshot(model: products, animatingDifferences: true)
        }
    }
    
    func fetchProductImage(for product: ProductsModel, cell: ProductCell) {
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

// MARK: ProductsPresenter: ProductsPresenterOutput
extension ProductsPresenter: ProductsPresenterOutput {
    func didSelectProduct(with productId: Int) {
        coordinator.showDetails(for: productId)
    }
}
