//
//OnboardingController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class OnboardingController: BaseController {
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.currentPageIndicatorTintColor = .atlasOrange
        page.pageIndicatorTintColor = .atlasSand
        page.addTarget(self, action: #selector(pageControllTapped), for: .valueChanged)
        page.translatesAutoresizingMaskIntoConstraints = false
        return page
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(WelcomeCell.self, forCellWithReuseIdentifier: WelcomeCell.identifier)
        collection.register(CuisinesCell.self, forCellWithReuseIdentifier: CuisinesCell.identifier)
        collection.register(JourneyCell.self, forCellWithReuseIdentifier: JourneyCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = .atlasOrange
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        view.backgroundColor = .atlasCream
    }
    
    override func configureConstraints() {
        view.addSubview(pageControl)
        view.addSubview(collection)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collection.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 8),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            button.topAnchor.constraint(equalTo: collection.bottomAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.88),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    override func configureViewModel() {
        pageControl.numberOfPages = viewModel.pageCount
        
        viewModel.nextCallback = { [weak self] in
            self?.configureOnboading()
        }
        
        viewModel.finishCallback = { [weak self] in
            self?.showHomePage()
        }
        
        viewModel.success = { [weak self] in
            self?.collection.reloadData()
        }
        
        viewModel.error = { errorMessage in
            print(errorMessage)
        }
        
        view.layoutIfNeeded()
        collection.reloadData()
        configureOnboading()
        viewModel.getCuisines()
    }
    
    private func configureOnboading() {
        collection.scrollToItem(at: IndexPath(item: viewModel.currentIndex, section: 0),
                                at: .centeredHorizontally,
                                animated: true)
        updatePage()
    }
    
    private func updatePage() {
        pageControl.currentPage = viewModel.currentIndex
        button.setTitle(viewModel.buttonText, for: .normal)
    }
    
    private func showHomePage() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.setHomeAsRoot()
        }
    }
    
    @objc private func pageControllTapped() {
        viewModel.currentIndex = pageControl.currentPage
        configureOnboading()
    }
    
    @objc private func buttonTapped() {
        viewModel.nextPage()
    }
}

extension OnboardingController: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WelcomeCell.identifier,
                                                                for: indexPath) as? WelcomeCell else {
            return UICollectionViewCell()
            }
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuisinesCell.identifier,
                                                                for: indexPath) as? CuisinesCell else {
                return UICollectionViewCell()
            }

            cell.configure(items: viewModel.cuisines,
                           selectedID: viewModel.selectedCuisineID,
                           countText: viewModel.countText)

            cell.selectCallback = { [weak self] index in
                guard let self else { return }
                viewModel.toggleSelection(index: index)

                cell.configure(items: viewModel.cuisines,
                               selectedID: viewModel.selectedCuisineID,
                               countText: viewModel.countText)
            }
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyCell.identifier,
                                                                for: indexPath) as? JourneyCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(features: viewModel.feauter)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        updatePage()
    }
}
