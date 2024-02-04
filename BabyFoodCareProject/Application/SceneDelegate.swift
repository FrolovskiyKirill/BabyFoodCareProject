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
        
        let window = UIWindow(windowScene: windowScene)
        let navigationControoler = UINavigationController()
        
        window.rootViewController = navigationControoler
        self.window = window
        window.makeKeyAndVisible()
        
        let appCoordinator = AppCoordinator(type: .app, navigationController: navigationControoler)
        appCoordinator.start()
    }
}

