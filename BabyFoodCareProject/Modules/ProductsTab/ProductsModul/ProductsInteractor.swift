//
//  ProductsInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

protocol ProductsInteractorInput {
    func getData()
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
protocol ProductsInteractorOutput { }

final class ProductsInteractor: ProductsInteractorInput {
    weak var presenter: ProductsPresenterInput?
    
    private let APIClient: ProductsProtocol
    private let apiImageClient: ImageProtocol
    
    var products: [ProductsModel]?
    
    init(APIClient: ProductsProtocol, apiImageClient: APIImageClient) {
        self.APIClient = APIClient
        self.apiImageClient = apiImageClient
    }
    
    // TODO: Добавить комплишн и в нем вызывать обтаинДата
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
    
    func fetchImageData(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
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

extension ProductsInteractor: ProductsInteractorOutput { }
