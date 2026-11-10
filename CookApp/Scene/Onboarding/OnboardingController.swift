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
        collection.register(WelcomeCell.self, forCellWithReuseIdentifier: "\(WelcomeCell.self)")
        collection.register(CuisinesCell.self, forCellWithReuseIdentifier: "\(CuisinesCell.self)")
        collection.register(JourneyCell.self, forCellWithReuseIdentifier: "\(JourneyCell.self)")
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
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .atlasOrange
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.addSubview(loadingView)
        
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
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func configureViewModel() {
        pageControl.numberOfPages = viewModel.pages.count
        
        viewModel.nextCallback = { [weak self] in
            self?.configureOnboading()
        }
        
        viewModel.finishCallback = { [weak self] in
            self?.showHomePage()
        }
        
        viewModel.stateChanged = { [weak self] in
            self?.configureState()
        }

        view.layoutIfNeeded()
        collection.reloadData()
        configureOnboading()
        viewModel.getCuisines()
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
        viewModel.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.pages[indexPath.item] {
        case .welcome:
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(WelcomeCell.self)",
                                                                for: indexPath) as? WelcomeCell else {
            return UICollectionViewCell()
            }
            
            return cell
        case .cuisines:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CuisinesCell.self)",
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
            
        case .journey:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(JourneyCell.self)",
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
