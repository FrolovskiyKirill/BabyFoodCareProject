//
//  FavoriteInteractor.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import Foundation

protocol FavoriteInteractorInput { }
protocol FavoriteInteractorOutput { }

final class FavoriteInteractor: FavoriteInteractorInput {
    weak var presenter: FavoritePresenterInput?
    
}

extension FavoriteInteractor: FavoriteInteractorOutput { }
