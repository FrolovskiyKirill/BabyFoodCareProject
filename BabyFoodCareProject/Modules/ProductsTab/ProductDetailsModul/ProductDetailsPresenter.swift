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
    private let apiClient: ProductDetailsProtocol
    private let coordinator: ProductDetailsCoordinator
    private let productId: Int
    
    init(apiClient: ProductDetailsProtocol, coordinator: ProductDetailsCoordinator, productId: Int) {
        self.apiClient = apiClient
        self.coordinator = coordinator
        self.productId = productId
    }
    
    func viewDidLoad() {
        Task {
            do {
                let productDetails = try await apiClient.getProductDetails(productID: productId)
                print("Loaded product details: \(productDetails.title)")
                // TODO: Передать данные в View когда UI будет готов
            } catch {
                print("Fetching product details failed with error \(error)")
            }
        }
    }
}

extension ProductDetailsPresenter: ProductDetailsPresenterInput { }

extension ProductDetailsPresenter: ProductDetailsPresenterOutput { }
