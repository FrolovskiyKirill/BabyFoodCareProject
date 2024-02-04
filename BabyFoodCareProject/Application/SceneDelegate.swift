//
//  SceneDelegate.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarController = UITabBarController()

        let productsView = ProductsAssembly.makeModule()
        productsView.tabBarItem = UITabBarItem(title: "Home", image: .actions, tag: 0)
        let productsNavigationController = UINavigationController(rootViewController: productsView)
        
        let favoriteView = FavoriteAssembly.makeModule()
        favoriteView.tabBarItem = UITabBarItem(title: "Favorite", image: .checkmark, tag: 2)
        let favoriteViewNavigationController = UINavigationController(rootViewController: favoriteView)

        let accountView = AccountAssembly.makeModule()
        accountView.tabBarItem = UITabBarItem(title: "Account", image: .add, tag: 2)
        let accountNavigationController = UINavigationController(rootViewController: accountView)

        tabBarController.viewControllers = [productsNavigationController, favoriteViewNavigationController, accountNavigationController]

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.window = window
    }
}

