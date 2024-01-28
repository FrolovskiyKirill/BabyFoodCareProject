//
//  ProductDetailsView.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

protocol IProductDetailsView: AnyObject {
    
}

class ProductDetailsView: UIViewController {
    var presenter: IProductDetailsPresentor?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
}

extension ProductDetailsView: IProductDetailsView {
    
}
