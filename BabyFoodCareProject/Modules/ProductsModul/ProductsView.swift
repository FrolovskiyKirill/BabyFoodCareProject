//
//  ProductsView.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

protocol IProductsView: AnyObject {
    func updateProducts(with products: [ProductsModel])
}

class ProductsView: UIViewController {
    var presenter: IProductsPresenter?
//    var authorities: [Authority] = [] // Данные для отображения
    var products: [ProductsModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100) // Укажите размер ячейки
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemYellow
        collectionView.register(ProductsCell.self, forCellWithReuseIdentifier: ProductsCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        presenter?.viewDidLoad()
    }
}

extension ProductsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCell.identifier, for: indexPath) as? ProductsCell else {
            fatalError("Unable to dequeue AuthorityCell")
        }
        let products = products[indexPath.item]
        cell.configure(with: products)
        return cell
    }
}

extension ProductsView: IProductsView {
    func updateProducts(with products: [ProductsModel]) {
        self.products = products
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// Вынести в отдельный файл
class ProductsCell: UICollectionViewCell {
    static let identifier = "ProductsCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nameLabel)
        nameLabel.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with products: ProductsModel) {
        nameLabel.text = products.title
    }
}
