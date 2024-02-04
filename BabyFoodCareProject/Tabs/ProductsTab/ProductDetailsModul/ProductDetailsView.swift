//
//  ProductDetailsView.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

protocol ProductDetailsViewInput: AnyObject { 
    
}
protocol ProductDetailsViewOutput: AnyObject { 
    func viewDidLoad()
}

final class ProductDetailsView: UIViewController {
    var presenter: ProductDetailsPresenterInput?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        presenter?.viewDidLoad()
    }
}

extension ProductDetailsView: ProductDetailsViewInput {
    
}

extension ProductDetailsView: ProductDetailsViewOutput {
    
}
