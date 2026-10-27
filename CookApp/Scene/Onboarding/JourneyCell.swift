//
//  JourneyCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 16.10.26.
//

import UIKit

class JourneyCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your cooking journey"
        label.textColor = .atlasDark
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Everything you need from \"that looks good\" to \"I made it\"."
        label.textColor = .atlasGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(JourneyFeaturesCell.self, forCellWithReuseIdentifier: JourneyFeaturesCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var footnoteLabel: UILabel = {
        let label = UILabel()
        label.text = """
            No account needed. Your data stays on this iPhone.
            
            Developed by CC · (Cool Coding programs)
            """
        label.textColor = .atlasGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var features: [Feature] = []
    
    static let identifier = "JourneyCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(collection)
        contentView.addSubview(footnoteLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.88),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            collection.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            collection.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            collection.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.56),
            
            footnoteLabel.topAnchor.constraint(equalTo: collection.bottomAnchor, constant: 20),
            footnoteLabel.leadingAnchor.constraint(equalTo: collection.leadingAnchor),
            footnoteLabel.trailingAnchor.constraint(equalTo: collection.trailingAnchor),
            
        ])
    }
    
    func configure(features: [Feature]) {
        self.features = features
        collection.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JourneyCell: CollectionConfiguration {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JourneyFeaturesCell.identifier,
                                                            for: indexPath) as? JourneyFeaturesCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(data: features[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: 100)
    }
}
