//
//  CookbookController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class CookbookController: BaseController {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CuisineRecipesCell.self, forCellWithReuseIdentifier: "\(CuisineRecipesCell.self)")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let viewModel = CookbookViewModel()
    
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getRecipes()
    }
    
    override func configureUI() {
        navigationItem.title = "Cookbook"
        view.backgroundColor = .atlasCream
        
        refreshControl.addTarget(self, action: #selector(refreshSavedData), for: .valueChanged)
        collection.refreshControl = refreshControl
    }
    
    override func configureConstraints() {
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.96),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func configureViewModel() {
        viewModel.stateChanged = { [weak self] in
            self?.configureState()
        }
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
            refreshControl.endRefreshing()
            
            if viewModel.recipes.isEmpty {
                showDefaultAlert(title: "No Saved Recipes",
                                 message: "Tap the bookmark on any recipe to save it to your Cookbook.")
            }
        case .error(let errorMessage):
            stopLoading()
            refreshControl.endRefreshing()
            showDefaultAlert(title: "Error", message: errorMessage)
        }
    }
    
    @objc private func refreshSavedData() {
        viewModel.getRecipes()
    }
}

extension CookbookController: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CuisineRecipesCell.self)",
                                                            for: indexPath) as? CuisineRecipesCell else {
            return UICollectionViewCell()
        }
        
        let recipe = viewModel.recipes[indexPath.item]
        cell.configureSaveButton(isSaved: true)
        cell.configureSaved(recipe: recipe)
        cell.saveCallback = { [weak self] in
            if let id = recipe.id {
                self?.viewModel.deleteRecipes(recipeID: id)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = viewModel.recipes[indexPath.item]
        
        if let navigationController,
           let id = recipe.id {
            let coordinator = RecipeDetailCoordinator(navigationController: navigationController, id: id)
            coordinator.start()
        }
    }
}
