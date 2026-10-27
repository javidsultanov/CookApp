//
//  IngredientsController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class IngredientsController: BaseController {
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Find an Ingredient"
        search.searchBarStyle = .minimal
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(top: 0, left: 0, bottom: 12, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(IngredientsCell.self, forCellWithReuseIdentifier: IngredientsCell.identifier)
        collection.register(CategoryHeader.self, forSupplementaryViewOfKind:
                                UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CategoryHeader.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let viewModel = IngredientsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        navigationItem.title = "Ingredients"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func configureConstraints() {
        view.addSubview(searchBar)
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: collection.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: collection.trailingAnchor),
            
            collection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.96),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func configureViewModel() {
        viewModel.success = { [weak self] in
            self?.collection.reloadData()
        }
        
        viewModel.error = { errorMessage in
            print(errorMessage)
        }
        
        viewModel.getIngredients()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension IngredientsController: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientsCell.identifier,
                                                            for: indexPath) as? IngredientsCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: viewModel.filteredIngredients[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: CategoryHeader.identifier,
                                                                           for: indexPath) as? CategoryHeader else {
            return UICollectionReusableView()
        }
        
        header.configure(categories: viewModel.categories, selectedIndex: viewModel.selectedCategoryIndex)
        
        header.categoryCallback = { [weak self] index in
            self?.viewModel.selectedCategoryIndex = index
            self?.viewModel.filterIngredients()
            self?.collection.reloadData()
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 16) / 3
        return .init(width: width, height: 160)
    }
}

extension IngredientsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
        viewModel.filterIngredients()
        collection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
