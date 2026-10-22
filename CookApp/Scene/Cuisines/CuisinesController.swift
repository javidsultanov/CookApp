//
//  CuisinesController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class CuisinesController: BaseController {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = .init(top: 0, left: 0, bottom: 24, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CuisineCardCell.self, forCellWithReuseIdentifier: CuisineCardCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let viewModel = CuisinesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        navigationItem.title = "World Cuisines"
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
        
        viewModel.error = {errorMessage in
            print(errorMessage)
        }
        
        viewModel.getCuisines()
    }
}

extension CuisinesController: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.cuisines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuisineCardCell.identifier,
                                                            for: indexPath) as? CuisineCardCell else {
            return UICollectionViewCell()
        }
        
        let cuisine = viewModel.cuisines[indexPath.item]
        cell.configure(data: cuisine, isFavorite: viewModel.isFavorite(cuisine: cuisine))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 24) / 2
        return .init(width: width, height: 180)
    }
}
