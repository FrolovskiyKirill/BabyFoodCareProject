//
//  ProductDetailsInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

protocol ProductDetailsInteractorInput {
    func getData()
    func getProductDetails(with productId: Int)
}

protocol ProductDetailsInteractorOutput { }

final class ProductDetailsInteractor: ProductDetailsInteractorInput {
    weak var presenter: ProductDetailsPresenterInput?
    let APIClient: ProductDetailsProtocol
    var productId: Int?
    
    var productDetails: ProductDetailsModel?
    
    init(APIClient: APIClient) {
        self.APIClient = APIClient
    }
    
    func getProductDetails(with productId: Int) {
        self.productId = productId
    }
}

extension ProductDetailsInteractor: ProductDetailsInteractorOutput {
    func getData() {
        guard let productId = productId else { return }
        Task.init {
            do {
                self.productDetails = try await APIClient.getProductDetails(productID: productId)
                guard let productDetails = productDetails else { return }
                print(productDetails.howToServe) // Убрать
            } catch {
                print("Fetching establishments failed with error \(error)")
            }
        }
    }
}
