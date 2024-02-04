//
//  FavoriteCoordinator.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

class FavoriteCoordinator: Coordinator {
    
    override func start() {
        let favoriteView = FavoriteAssembly.makeModule()
        navigationController?.pushViewController(favoriteView, animated: true)
    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
}
