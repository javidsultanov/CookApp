//
//  CuisineRecipesController.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import UIKit

class CuisineRecipesController: BaseController {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CuisineRecipesCell.self, forCellWithReuseIdentifier: "\(CuisineRecipesCell.self)")
        collection.register(CuisineHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "\(CuisineHeader.self)")
        collection.register(DifficultyHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "\(DifficultyHeader.self)")
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
    
    private let viewModel: CuisineRecipesViewModel
    
    init(viewModel: CuisineRecipesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collection.reloadData()
    }
    
    override func configureUI() {
        navigationItem.title = viewModel.cuisine.name
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

        viewModel.getCuisineRecipes()
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
}

extension CuisineRecipesController: CollectionConfiguration {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections[section].recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CuisineRecipesCell.self)",
                                                            for: indexPath) as? CuisineRecipesCell else {
            return UICollectionViewCell()
        }
        
        let recipe = viewModel.sections[indexPath.section].recipes[indexPath.item]
        cell.configure(data: recipe)
        cell.configureSaveButton(isSaved: viewModel.isSaved(recipe: recipe))
        cell.saveCallback = { [weak self] in
            self?.viewModel.saveButtonTapped(recipe: recipe)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "\(CuisineHeader.self)",
                                                                               for: indexPath) as? CuisineHeader else {
                return UICollectionReusableView()
            }
            
            header.configure(data: viewModel.cuisine, section: viewModel.sections[indexPath.section])
            return header
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: "\(DifficultyHeader.self)",
                                                                           for: indexPath) as? DifficultyHeader else {
            return UICollectionReusableView()
        }
        
        header.configure(data: viewModel.sections[indexPath.section])
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: section == 0 ? 360 : 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width , height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        
        let recipe = viewModel.sections[indexPath.section].recipes[indexPath.item]
        let coordinator = RecipeDetailCoordinator(navigationController: navigationController,
                                                  id: recipe.id ?? 0)
        coordinator.start()
    }
}
