//
//  AppCoordinator.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    override func start() {
        showMainFlow()
    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
    
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
        type = .products
    }

    func didSelectTad(with index: Int) {
        guard index >= 0 && index < childCoordinators.count else { return }
        if let productIndex = childCoordinators.firstIndex(where: { $0 is ProductsCoordinator }),
           productIndex == index {
            childCoordinators[index].navigationController?.popToRootViewController(animated: false)
        }
    }
}

private extension AppCoordinator {
    func showMainFlow() {
        let productsNavigationController = UINavigationController()
        let productsCoordinator = ProductsCoordinator(type: .products, navigationController: productsNavigationController)
        productsNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "square.grid.2x2"), tag: 0)
        productsCoordinator.finishDelegate = self
        productsCoordinator.start()
        
        let favoriteNavigationController = UINavigationController()
        let favoriteCoordinator = FavoriteCoordinator(type: .favorite, navigationController: favoriteNavigationController)
        favoriteNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "heart"), tag: 0)
        favoriteCoordinator.finishDelegate = self
        favoriteCoordinator.start()
        
        let accountNavigationController = UINavigationController()
        let accountCoordinator = AccountCoordinator(type: .account, navigationController: accountNavigationController)
        accountNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage.init(systemName: "person"), tag: 0)
        accountCoordinator.finishDelegate = self
        accountCoordinator.start()
        
        addChildCoordinator(productsCoordinator)
        addChildCoordinator(favoriteCoordinator)
        addChildCoordinator(accountCoordinator)
        
        let tabBarControllers = [productsNavigationController, favoriteNavigationController, accountNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers, appCoordinator: self)

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .products:
            return
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
