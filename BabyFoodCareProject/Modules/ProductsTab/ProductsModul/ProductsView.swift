//
//  ProductsView.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import UIKit

protocol ProductsViewInput: AnyObject { }

protocol ProductsViewOutput: AnyObject {
    func viewDidLoad()
    func setupInitialState()
    func didSelectProduct(with id: Int)
    func applySnapshot(model: [ProductsModel], animatingDifferences: Bool)
    func endRefreshing()
}

final class ProductsView: UIViewController {
    enum Section {
      case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ProductsModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ProductsModel>
    
    //MARK: Properties
    var presenter: ProductsPresenterInput?
    
    private lazy var dataSource = makeDataSource()
    private lazy var collectionView: UICollectionView! = nil
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = String(localized: "Search Products")
        return searchController
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()

    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    //MARK: Methods
    func setupInitialState() {
        setupCollectionView()
        setupInterface()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    @objc private func handleRefresh() {
        presenter?.refreshData()
    }
    
    func applySnapshot(model: [ProductsModel], animatingDifferences: Bool) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(model)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, model) -> UICollectionViewCell? in
                if let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductCell.identifier,
                    for: indexPath) as? ProductCell {
                    cell.model = model
                    self.presenter?.fetchProductImage(for: model, cell: cell)
                    return cell
                }
                return nil
            })
        return dataSource
    }
}

//MARK: Private extension
private extension ProductsView {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
    }
    
    func setupInterface() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 42, weight: .bold)]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        title = "Baby Food Care"
    }
}

// MARK: ProductsView: UICollectionViewDelegate
extension ProductsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = dataSource.itemIdentifier(for: indexPath)?.id else {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        presenter?.didSelectProduct(with: id)
    }
}

// MARK: ProductsView: ProductsViewOutput
extension ProductsView: ProductsViewOutput {
    func didSelectProduct(with id: Int) { }
}

// MARK: ProductsView: UISearchResultsUpdating
extension ProductsView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            presenter?.resetSearch()
            return
        }
        presenter?.searchProducts(with: query)
    }
}
