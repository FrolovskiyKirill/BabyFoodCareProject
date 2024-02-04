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
}

private extension AppCoordinator {
    func showMainFlow() {
        guard let navigationController = navigationController else { return }
        
        let productsNavigationController = UINavigationController()
        let productsCoordinator = ProductsCoordinator(type: .products, navigationController: productsNavigationController)
        productsNavigationController.tabBarItem = UITabBarItem(title: "Products", image: UIImage.init(systemName: "swirl.circle.righthalf.filled"), tag: 0)
        productsCoordinator.finishDelegate = self
        productsCoordinator.start()
        
        let favoriteNavigationController = UINavigationController()
        let favoriteCoordinator = FavoriteCoordinator(type: .products, navigationController: favoriteNavigationController)
        favoriteNavigationController.tabBarItem = UITabBarItem(title: "Products", image: UIImage.init(systemName: "swirl.circle.righthalf.filled"), tag: 0)
        favoriteCoordinator.finishDelegate = self
        favoriteCoordinator.start()
        
        let accountNavigationController = UINavigationController()
        let accountCoordinator = AccountCoordinator(type: .products, navigationController: accountNavigationController)
        accountNavigationController.tabBarItem = UITabBarItem(title: "Products", image: UIImage.init(systemName: "swirl.circle.righthalf.filled"), tag: 0)
        accountCoordinator.finishDelegate = self
        accountCoordinator.start()
        
        addChildCoordinator(productsCoordinator)
        addChildCoordinator(favoriteCoordinator)
        addChildCoordinator(accountCoordinator)
        
        let tabBarControllers = [productsNavigationController, favoriteNavigationController, accountNavigationController]
        let tabBarController = TabBarController(tabBarControllers: tabBarControllers)
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: CoordinatorProtocol) {
        removeChildCoordinator(childCoordinator)
        
        switch childCoordinator.type {
        case .app:
            return
        default:
            navigationController?.popToRootViewController(animated: false)
        }
    }
}
