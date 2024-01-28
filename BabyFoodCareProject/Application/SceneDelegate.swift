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
        let navBarController = UINavigationController(rootViewController: tabBarController)
        
        let productsView = ProductsAssembly.makeModule()
        productsView.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        let productDetailsView = ProductDetailsAssembly.makeModule()
        productDetailsView.tabBarItem = UITabBarItem(title: "Detail", image: nil, tag: 1)
        
        tabBarController.viewControllers = [productsView, productDetailsView]
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }
}

