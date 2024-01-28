//
//  ProductsCell.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

//import UIKit
//
//class ProductsCell: UICollectionViewCell {
//    static let identifier = "ProductsCell"
//    
//    private let nameLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.addSubview(nameLabel)
//        nameLabel.frame = contentView.bounds
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func configure(with products: ProductsModel) {
//        nameLabel.text = products.title
//    }
//}
