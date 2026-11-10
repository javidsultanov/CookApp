//
//  IngredientRecipesController.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.10.26.
//

import UIKit

class IngredientRecipesController: BaseController {
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
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .atlasOrange
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let viewModel: IngredientRecipesViewModel
    
    init(viewModel: IngredientRecipesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collection.reloadData()
    }
    
    override func configureUI() {
        navigationItem.title = viewModel.ingredient.name
        view.backgroundColor = .atlasCream
    }
    
    override func configureConstraints() {
        view.addSubview(collection)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        
        viewModel.getIngredientRecipes()
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
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IngredientRecipesController: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CuisineRecipesCell.self)",
                                                            for: indexPath) as? CuisineRecipesCell else {
            return UICollectionViewCell()
        }
        
        let recipe = viewModel.recipes[indexPath.item]
        cell.configure(data: recipe)
        cell.configureSaveButton(isSaved: viewModel.isSaved(recipe: recipe))
        cell.saveCallback = { [weak self] in
            self?.viewModel.saveButtonTapped(recipe: recipe)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        
        let recipe = viewModel.recipes[indexPath.item]
        let coordinator = RecipeDetailCoordinator(navigationController: navigationController,
                                                  id: recipe.id ?? 0)
        coordinator.start()
    }
}
