//
//  CuisineRecipesController.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import UIKit

class CuisineRecipesController: BaseController {
    private lazy var cuisineImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.backgroundColor = .atlasPeach
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .atlasDark
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .atlasGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    override func configureUI() {
        navigationItem.title = viewModel.cuisine.name
        
        cuisineImageView.loadImage(url: viewModel.cuisine.imageURL ?? "")
        nameLabel.text = "\(viewModel.cuisine.flagEmoji ?? "") \(viewModel.cuisine.name ?? "")"
        descriptionLabel.text = viewModel.cuisine.description
    }
    
    override func configureConstraints() {
        view.addSubview(cuisineImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            cuisineImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            cuisineImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cuisineImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.92),
            cuisineImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.28),
            
            nameLabel.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: cuisineImageView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            collection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            collection.leadingAnchor.constraint(equalTo: cuisineImageView.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: cuisineImageView.trailingAnchor),
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
        
        viewModel.getCuisineRecipes()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuisineRecipesCell.identifier,
                                                            for: indexPath) as? CuisineRecipesCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: viewModel.sections[indexPath.section].recipes[indexPath.item])
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
        .init(width: collectionView.frame.width , height: 96)
    }
}
