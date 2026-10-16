//
//  CuisinesCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 15.10.26.
//

import UIKit

class CuisinesCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Which cuisines do you love?"
        label.textColor = UIColor(red: 42/255, green: 31/255, blue: 23/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick a few. We'll show recipes from them first. You can change this anytime in Settings."
        label.textColor = UIColor(red: 110/255, green: 96/255, blue: 84/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(SelectCuisineCell.self, forCellWithReuseIdentifier: SelectCuisineCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 110/255, green: 96/255, blue: 84/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectCallback: ((Int) -> Void)?
    
    private var items: [Cuisine] = []
    private var selectedID: [Int] = []
    
    static let identifier = "CuisinesCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.88),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: countLabel.topAnchor, constant: -12),
            
            countLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            countLabel.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])
    }
    
    func configure(items: [Cuisine], selectedID: [Int], countText: String) {
        self.items = items
        self.selectedID = selectedID
        countLabel.text = countText
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CuisinesCell: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectCuisineCell.identifier,
                                                            for: indexPath) as? SelectCuisineCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: items[indexPath.item], selected: selectedID.contains(items[indexPath.item].id ?? 0))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCallback?(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 12) / 2
        return .init(width: width, height: 132)
    }
}
