//
//  CategoryHeader.swift
//  CookApp
//
//  Created by Javid Sultanov on 26.10.26.
//

import UIKit

class CategoryHeader: UICollectionReusableView {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private var categories: [String] = []
    private var selectedIndex: Int?
    
    var categoryCallback: ((Int?) -> Void)?
    
    static let identifier = "CategoryHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
        
    private func configureConstraints() {
        addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor),
            collection.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(categories: [String], selectedIndex: Int?) {
        self.categories = categories
        self.selectedIndex = selectedIndex
        collection.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryHeader: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath.item {
            selectedIndex = nil
        } else {
            selectedIndex = indexPath.item
        }
        
        collection.reloadData()
        categoryCallback?(selectedIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier,
                                                            for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(category: categories[indexPath.item], selected: indexPath.item == selectedIndex)
        return cell
    }
}
