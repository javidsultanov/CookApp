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
        layout.sectionInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(IngredientsCell.self, forCellWithReuseIdentifier: "\(IngredientsCell.self)")
        collection.register(CategoryHeader.self, forSupplementaryViewOfKind:
                                UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "\(CategoryHeader.self)")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .atlasOrange
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel = IngredientsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        navigationItem.title = "Ingredients"
        view.backgroundColor = .atlasCream
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func configureConstraints() {
        view.addSubview(searchBar)
        view.addSubview(collection)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: collection.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: collection.trailingAnchor),
            
            collection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.96),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func configureViewModel() {
        viewModel.stateChanged = { [weak self] in
            self?.configureState()
        }
        
        viewModel.getIngredients()
    }
    
    override func configureState() {
        switch viewModel.state {
        case .idle:
            break
        case .loading:
            startLoading()
        case .loaded:
            stopLoading()
            collection.reloadData()
        case .error(let errorMessage):
            stopLoading()
            showDefaultAlert(title: "Error", message: errorMessage)
        }
    }
    
    override func startLoading() {
        view.bringSubviewToFront(loadingView)
        loadingView.startAnimating()
    }
    
    override func stopLoading() {
        loadingView.stopAnimating()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(IngredientsCell.self)",
                                                            for: indexPath) as? IngredientsCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: viewModel.filteredIngredients[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: "\(CategoryHeader.self)",
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        
        let coordinator = IngredientRecipesCoordinator(navigationController: navigationController,
                                                       ingredient: viewModel.filteredIngredients[indexPath.item])
        coordinator.start()
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
