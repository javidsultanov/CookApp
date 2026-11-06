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
        layout.sectionInset = .init(top: 8, left: 0, bottom: 16, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CuisineRecipesCell.self, forCellWithReuseIdentifier: "\(CuisineRecipesCell.self)")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No saved recipes yet.\nTap the bookmark on any recipe to save it here."
        label.textColor = .atlasGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.96),
            collection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80)
        ])
    }
    
    override func configureViewModel() {
        viewModel.success = { [weak self] in
            guard let self else { return }
            emptyLabel.isHidden = !viewModel.recipes.isEmpty
            collection.reloadData()
            refreshControl.endRefreshing()
        }
        
        viewModel.error = { errorMessage in
            print(errorMessage)
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
        cell.configureSaved(entity: recipe)
        cell.saveCallback = { [weak self] in
            self?.viewModel.deleteRecipes(recipeID: Int(recipe.recipeID))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        
        let recipe = viewModel.recipes[indexPath.item]
        let coordinator = RecipeDetailCoordinator(navigationController: navigationController,
                                                  id: Int(recipe.recipeID))
        coordinator.start()
    }
}
