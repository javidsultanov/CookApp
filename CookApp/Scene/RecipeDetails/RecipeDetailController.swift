//
//  RecipeDetailController.swift
//  CookApp
//
//  Created by Javid Sultanov on 05.11.26.
//

import UIKit
import YouTubePlayerKit

class RecipeDetailController: BaseController {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.sectionInset = .init(top: 0, left: 0, bottom: 16, right: 0)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(RecipeIngredientsCell.self, forCellWithReuseIdentifier: "\(RecipeIngredientsCell.self)")
        collection.register(RecipeStepsCell.self, forCellWithReuseIdentifier: "\(RecipeStepsCell.self)")
        collection.register(RecipeInfoHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "\(RecipeInfoHeader.self)")
        collection.register(DetailTitleHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "\(DetailTitleHeader.self)")
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var youtubeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Watch on YouTube", for: .normal)
        button.setImage(UIImage(systemName: "play.rectangle.fill"), for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .atlasOrange
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(youtubeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var saveButton = UIBarButtonItem(image: UIImage(systemName: "bookmark"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(saveButtonTapped))
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .atlasOrange
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: RecipeDetailViewModel
    
    init(viewModel: RecipeDetailViewModel) {
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
        viewModel.checkSaved()
    }
    
    override func configureUI() {
        view.backgroundColor = .atlasCream
        navigationItem.rightBarButtonItem = saveButton
        saveButton.tintColor = .atlasOrange
    }
    
    override func configureConstraints() {
        view.addSubview(collection)
        view.addSubview(youtubeButton)
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.96),
            collection.bottomAnchor.constraint(equalTo: youtubeButton.topAnchor, constant: -8),
            
            youtubeButton.leadingAnchor.constraint(equalTo: collection.leadingAnchor),
            youtubeButton.trailingAnchor.constraint(equalTo: collection.trailingAnchor),
            youtubeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            youtubeButton.heightAnchor.constraint(equalToConstant: 52),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
        
    override func configureViewModel() {
        viewModel.stateChanged = { [weak self] in
            self?.configureState()
        }
        
        viewModel.getRecipeDetail()
    }
    
    override func configureState() {
        switch viewModel.state {
        case .idle:
            break
        case .loading:
            startLoading()
        case .loaded:
            stopLoading()
            navigationItem.title = viewModel.recipeDetail?.title
            collection.reloadData()
            configureSaveButton()
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
    
    @objc private func youtubeButtonTapped() {
        guard let url = viewModel.youtubeLink else { return }
        
        guard let source = YouTubePlayer.Source(url: url) else {
            UIApplication.shared.open(url)
            return
        }
        
        let player = YouTubePlayer(source: source, parameters: .init(autoPlay: true))
        present(YouTubePlayerViewController(player: player), animated: true)
    }
    
    @objc private func saveButtonTapped() {
        viewModel.saveButtonTapped()
    }
    
    private func configureSaveButton() {
        saveButton.image = UIImage(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
    }
}

extension RecipeDetailController: CollectionConfiguration {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.recipeDetail == nil ? 0 : viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.sections[section] {
        case .ingredients:
            return viewModel.ingredients.count
        case .instructions:
            return viewModel.steps.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sections[indexPath.section] {
        case .ingredients:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeIngredientsCell.self)",
                                                                for: indexPath) as? RecipeIngredientsCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(data: viewModel.ingredients[indexPath.item])
            return cell
            
        case .instructions:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecipeStepsCell.self)",
                                                                for: indexPath) as? RecipeStepsCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(step: viewModel.steps[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch viewModel.sections[indexPath.section] {
        case .ingredients:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "\(RecipeInfoHeader.self)",
                                                                               for: indexPath) as? RecipeInfoHeader,
                  let recipe = viewModel.recipeDetail else {
                return UICollectionReusableView()
            }
            
            header.configure(data: recipe)
            return header
            
        case .instructions:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: "\(DetailTitleHeader.self)",
                                                                               for: indexPath) as? DetailTitleHeader else {
                return UICollectionReusableView()
            }
            
            header.configure(title: "Instructions", count: "\(viewModel.steps.count) steps")
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch viewModel.sections[section] {
        case .ingredients:
            return .init(width: collectionView.frame.width, height: 440)
        case .instructions:
            return .init(width: collectionView.frame.width, height: 48)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.sections[indexPath.section] {
        case .ingredients:
            return .init(width: collectionView.frame.width, height: 64)
        case .instructions:
            return .init(width: collectionView.frame.width, height: 84)
        }
    }
}
