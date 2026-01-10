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
    func refreshData()
}

protocol ProductsPresenterOutput: AnyObject { 
    func didSelectProduct(with productId: Int)
}

@MainActor
final class ProductsPresenter {
    
// MARK: Properties
    weak var view: ProductsViewOutput?
    private let apiClient: ProductsProtocol
    private let apiImageClient: ImageProtocol
    private let coordinator: ProductsCoordinator
    private let toastService: ToastServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    private var products: [ProductsModel] = []
    private var filteredProducts: [ProductsModel] = []
    
    init(
        apiClient: ProductsProtocol,
        apiImageClient: ImageProtocol,
        coordinator: ProductsCoordinator,
        toastService: ToastServiceProtocol,
        cacheService: CacheServiceProtocol
    ) {
        self.apiClient = apiClient
        self.apiImageClient = apiImageClient
        self.coordinator = coordinator
        self.toastService = toastService
        self.cacheService = cacheService
    }
    
    // MARK: Private Methods
    
    /// Fetches products using Network-first strategy with cache fallback
    private func getData() {
        Task {
            let cacheKey = CacheKey.products()
            
            do {
                // Network-first: try to fetch from API
                let products = try await apiClient.getProducts()
                self.products = products
                
                // Cache the successful response
                await cacheService.set(products, for: cacheKey)
                
                self.view?.applySnapshot(model: products, animatingDifferences: true)
            } catch {
                print("Fetching products failed with error \(error)")
                
                // Fallback to stale cache on network error
                if let cachedProducts: [ProductsModel] = await cacheService.getStale(for: cacheKey) {
                    self.products = cachedProducts
                    self.view?.applySnapshot(model: cachedProducts, animatingDifferences: true)
                    toastService.showToast(style: .neutral, message: String(localized: "Showing cached data"))
                } else {
                    toastService.showToast(style: .negative, message: String(localized: "Failed to load products"))
                }
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
        Task {
            do {
                let imageData = try await apiImageClient.fetchImage(urlString: product.imageURL)
                let image = UIImage(data: imageData)
                cell.updateImage(image)
            } catch {
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
    
    /// Pull-to-refresh: force update from network, invalidate cache
    func refreshData() {
        Task {
            let cacheKey = CacheKey.products()
            
            // Invalidate cache before refresh
            await cacheService.invalidate(for: cacheKey)
            
            do {
                let products = try await apiClient.getProducts()
                self.products = products
                
                // Cache the new data
                await cacheService.set(products, for: cacheKey)
                
                self.view?.applySnapshot(model: products, animatingDifferences: true)
                self.view?.endRefreshing()
                toastService.showToast(style: .positive, message: String(localized: "Products updated"))
            } catch {
                print("Refreshing products failed with error \(error)")
                self.view?.endRefreshing()
                toastService.showToast(style: .negative, message: String(localized: "Failed to refresh products"))
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
