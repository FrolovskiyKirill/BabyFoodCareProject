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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

protocol ProductsPresenterOutput: AnyObject { }

final class ProductsPresenter: NSObject {
    weak var view: ProductsViewOutput?
    var interactor: ProductsInteractorInput
    var coordinator: ProductsCoordinator
    
    private var products: [ProductsModel] = []
    
    init(interactor: ProductsInteractorInput, coordinator: ProductsCoordinator) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
}

extension ProductsPresenter: ProductsPresenterInput { 
    func viewDidLoad() {
        interactor.getData()
        view?.setupInitialState()
    }
    
    func obtainedData(products: [ProductsModel]) {
        self.products = products
        view?.reloadCollectionView()
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

extension ProductsPresenter: UICollectionViewDelegate, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCell.identifier, for: indexPath) as? ProductsCell else {
            fatalError("Unable to dequeue ProductCell")
        }
        let product = products[indexPath.item]
        fetchProductImage(for: product, cell: cell)
        cell.configure(with: product)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectProduct(with: products[indexPath.row].id)
    }

}

extension ProductsPresenter: ProductsPresenterOutput {
    func didSelectProduct(with productId: Int) {
        coordinator.showDetails(for: productId)
    }
}
