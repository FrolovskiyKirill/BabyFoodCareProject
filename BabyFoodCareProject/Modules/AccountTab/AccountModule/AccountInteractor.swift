//
//  AccountInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import Foundation

protocol AccountInteractorInput { }
protocol AccountInteractorOutput { }

final class AccountInteractor: AccountInteractorInput {
    weak var presenter: AccountPresenterInput?
    
}

extension AccountInteractor: AccountInteractorOutput { }
