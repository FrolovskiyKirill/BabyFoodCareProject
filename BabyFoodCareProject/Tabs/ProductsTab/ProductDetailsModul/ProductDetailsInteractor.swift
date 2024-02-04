//
//  ProductDetailsInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

protocol ProductDetailsInteractorInput {
    func getData()
}
protocol ProductDetailsInteractorOutput { 
    
}

final class ProductDetailsInteractor: ProductDetailsInteractorInput {
    weak var presenter: ProductDetailsPresenterInput?
    let APIClient: ProductDetailsProtocol
    
    let poductID: Int = 8
    var productDetails: ProductDetailsModel?
    
    init(APIClient: APIClient) {
        self.APIClient = APIClient
    }
}

extension ProductDetailsInteractor: ProductDetailsInteractorOutput {
    func getData() {
        Task.init {
            do {
                self.productDetails = try await APIClient.getProductDetails(poductID: poductID)
                guard let productDetails = productDetails else { return }
                print(productDetails.title) // Убрать
            } catch {
                print("Fetching establishments failed with error \(error)")
            }
        }
    }
}
