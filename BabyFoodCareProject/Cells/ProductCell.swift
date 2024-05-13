//
//  ProductCell.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 13.05.2024.
//

import UIKit

class ProductCell: UICollectionViewCell {
    static let identifier = "ProductCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let foodTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let ageFrom: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let dangerAttention: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 0.89, green: 0.45, blue: 0.45, alpha: 1.0)
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = UIColor(red: 0xDB/255, green: 0xD8/255, blue: 0xDD/255, alpha: 1.0)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0xDB/255, green: 0xD8/255, blue: 0xDD/255, alpha: 1.0).cgColor
        return button
    }()
    
    private let triedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "fork.knife"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0x0B/255, green: 0xCE/255, blue: 0x83/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(foodTitle)
        contentView.addSubview(ageFrom)
        contentView.addSubview(dangerAttention)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(triedButton)
        contentView.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        foodTitle.translatesAutoresizingMaskIntoConstraints = false
        ageFrom.translatesAutoresizingMaskIntoConstraints = false
        dangerAttention.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        triedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 177),
            imageView.heightAnchor.constraint(equalToConstant: 128),
            
            foodTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            foodTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            foodTitle.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            ageFrom.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            ageFrom.topAnchor.constraint(equalTo: foodTitle.bottomAnchor, constant: 10),
            ageFrom.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            dangerAttention.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            dangerAttention.topAnchor.constraint(equalTo: ageFrom.bottomAnchor, constant: 10),
            dangerAttention.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            favoriteButton.topAnchor.constraint(equalTo: dangerAttention.bottomAnchor, constant: 10),
            favoriteButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            favoriteButton.heightAnchor.constraint(equalToConstant: 36),
            
            triedButton.topAnchor.constraint(equalTo: dangerAttention.bottomAnchor, constant: 10),
            triedButton.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: 20),
            triedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            triedButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            triedButton.heightAnchor.constraint(equalToConstant: 36),
            triedButton.widthAnchor.constraint(equalTo: favoriteButton.widthAnchor)
        ])
    }
    
    func updateImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    var model: ProductsModel? {
      didSet {
          foodTitle.text = model?.title
          ageFrom.text = "From: \(String(describing: model?.monthFrom)) month"
          dangerAttention.text = "Danger: Allergen"
      }
    }
}
