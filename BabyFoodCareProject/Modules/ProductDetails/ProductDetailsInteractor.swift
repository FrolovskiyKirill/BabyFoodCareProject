//
//  ProductDetailsInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

protocol IProductDetailsInteractor {
    func getData()
}

class ProductDetailsInteractor: IProductDetailsInteractor {
    weak var presenter: IProductDetailsPresentor?
    let APIClient: ProductDetailsProtocol
    
    let poductID: Int = 8
    var productDetails: [ProductDetailsModel]?
    
    init(APIClient: APIClient) {
        self.APIClient = APIClient
    }
    
    func getData() {
        Task.init {
            do {
                self.productDetails = try await APIClient.getProductDetails(poductID: poductID)
                guard let productDetails = productDetails else { return }
                print(productDetails.first ?? "NO DATA") // Убрать
            } catch {
                print("Fetching establishments failed with error \(error)")
            }
        }
    }
}
