//
//  AccountCoordinator.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

class AccountCoordinator: Coordinator {
    
    override func start() {
        let accountView = AccountAssembly.makeModule()
        navigationController?.pushViewController(accountView, animated: true)
    }
    
    override func finish() {
        print("AppCoordinator finish")
    }
}
