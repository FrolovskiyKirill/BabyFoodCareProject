//
//  AccountPresenter.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import Foundation

protocol AccountPresenterInput: AnyObject {
    func viewDidLoad()
}

protocol AccountPresenterOutput: AnyObject {
}

final class AccountPresenter {
    weak var view: AccountViewOutput?
    var router: AccountRouterProtocol
    
    init(router: AccountRouterProtocol) {
        self.router = router
    }
}

extension AccountPresenter: AccountPresenterInput {
    func viewDidLoad() {
        print("!!!!!BYEEEEE")
    }
}

extension AccountPresenter: AccountPresenterOutput {

}
