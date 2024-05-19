//
//  FavoriteView.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 04.02.2024.
//

import UIKit

protocol FavoriteViewInput: AnyObject {
    
}
protocol FavoriteViewOutput: AnyObject {
    func viewDidLoad()
}

final class FavoriteView: UIViewController {
    var presenter: FavoritePresenterInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter?.viewDidLoad()
    }
}

extension FavoriteView: FavoriteViewOutput {
    
}
