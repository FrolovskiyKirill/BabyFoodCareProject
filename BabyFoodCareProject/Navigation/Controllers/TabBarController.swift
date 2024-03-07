//
//  TabBarController.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    
    weak var appCoordinator: AppCoordinator?
    
    init(tabBarControllers: [UIViewController], appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        super.init(nibName: nil, bundle: nil)
        for tab in tabBarControllers {
            self.addChild(tab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        appCoordinator?.didSelectTad(with: selectedIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .clear
        tabBar.tintColor = .black
    }
}
