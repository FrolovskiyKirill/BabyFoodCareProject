//
//  ProductsPresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

protocol ProductsPresenterInput: AnyObject {
    func viewDidLoad()
    func didSelectProduct(with productId: Int)
    func fetchProductImage(for product: ProductsModel, cell: ProductCell)
    func searchProducts(with query: String)
    func resetSearch()
}

protocol ProductsPresenterOutput: AnyObject { 
    func didSelectProduct(with productId: Int)
}

final class ProductsPresenter {
    
// MARK: Properties
    weak var view: ProductsViewOutput?
    private let apiClient: ProductsProtocol
    private let apiImageClient: ImageProtocol
    private let coordinator: ProductsCoordinator
    
    private var products: [ProductsModel] = []
    private var filteredProducts: [ProductsModel] = []
    
    init(apiClient: ProductsProtocol, apiImageClient: ImageProtocol, coordinator: ProductsCoordinator) {
        self.apiClient = apiClient
        self.apiImageClient = apiImageClient
        self.coordinator = coordinator
    }
    
    // MARK: Private Methods
    private func getData() {
        Task {
            do {
                let products = try await apiClient.getProducts()
                DispatchQueue.main.async {
                    self.products = products
                    self.view?.applySnapshot(model: products, animatingDifferences: true)
                }
            } catch {
                print("Fetching products failed with error \(error)")
            }
        }
    }
    
    private func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        Task {
            do {
                let imageData = try await apiImageClient.fetchImage(urlString: urlString)
                completion(.success(imageData))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: ProductsPresenter: ProductsPresenterInput
extension ProductsPresenter: ProductsPresenterInput {
    func viewDidLoad() {
        view?.setupInitialState()
        getData()
    }
    
    func fetchProductImage(for product: ProductsModel, cell: ProductCell) {
        fetchImageData(urlString: product.imageURL) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.updateImage(image)
                }
            case .failure(let error):
                print("Ошибка загрузки изображения: \(error)")
            }
        }
    }
    
    func searchProducts(with query: String) {
        let lowercasedQuery = query.lowercased()
        filteredProducts = products.filter { $0.title.lowercased().contains(lowercasedQuery) }
        view?.applySnapshot(model: filteredProducts, animatingDifferences: true)
    }
    
    func resetSearch() {
        view?.applySnapshot(model: products, animatingDifferences: true)
    }

}

// MARK: ProductsPresenter: ProductsPresenterOutput
extension ProductsPresenter: ProductsPresenterOutput {
    func didSelectProduct(with productId: Int) {
        coordinator.showDetails(for: productId)
    }
}
