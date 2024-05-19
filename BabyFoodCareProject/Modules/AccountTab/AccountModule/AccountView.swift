//
//  AccountView.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

protocol AccountViewInput: AnyObject {
    
}
protocol AccountViewOutput: AnyObject {
    func viewDidLoad()
}

final class AccountView: UIViewController {
    var presenter: AccountPresenterInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        presenter?.viewDidLoad()
    }
}

extension AccountView: AccountViewOutput {
    
}
