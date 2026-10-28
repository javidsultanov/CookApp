//
//  RecipesController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class RecipesController: BaseController {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CuisineRecipesCell.self, forCellWithReuseIdentifier: CuisineRecipesCell.identifier)
        collection.register(DifficultyHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: DifficultyHeader.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let viewModel = RecipesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        navigationItem.title = "Recipes"
        view.backgroundColor = .atlasCream
    }
    
    override func configureConstraints() {
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
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
        
        viewModel.getRecipes()
    }
}

extension RecipesController: CollectionConfiguration {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sections[section].recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuisineRecipesCell.identifier,
                                                            for: indexPath) as? CuisineRecipesCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: viewModel.sections[indexPath.section].recipes[indexPath.item], showCuisine: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: DifficultyHeader.identifier,
                                                                           for: indexPath) as? DifficultyHeader else {
            return UICollectionReusableView()
        }
        
        header.configure(data: viewModel.sections[indexPath.section])
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 96)
    }
}
