//
//  ProductsInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

protocol IProductsInteractor {
    func getData()
}

class ProductsInteractor: IProductsInteractor {
    weak var presenter: IProductsPresenter?
    let APIClient: ProductsProtocol
    
//    var authority: [Authority]?
    var products: [ProductsModel]?
    
    init(APIClient: APIClient) {
        self.APIClient = APIClient
    }
    
    func getData() {
        Task.init {
            do {
                self.products = try await APIClient.getProducts()
                guard let products = products else { return }
                self.presenter?.obtainedData(products: products)
            } catch {
                print("Fetching establishments failed with error \(error)")
            }
        }
    }
}
