//
//  CuisineHeader.swift
//  CookApp
//
//  Created by Javid Sultanov on 05.11.26.
//

import UIKit

class CuisineHeader: UICollectionReusableView {
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
    
    private lazy var difficultyHeader: DifficultyHeader = {
        let header = DifficultyHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        addSubview(cuisineImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(difficultyHeader)
        
        NSLayoutConstraint.activate([
            cuisineImageView.topAnchor.constraint(equalTo: topAnchor),
            cuisineImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cuisineImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cuisineImageView.heightAnchor.constraint(equalToConstant: 240),
            
            nameLabel.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cuisineImageView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            difficultyHeader.leadingAnchor.constraint(equalTo: leadingAnchor),
            difficultyHeader.trailingAnchor.constraint(equalTo: trailingAnchor),
            difficultyHeader.heightAnchor.constraint(equalToConstant: 48),
            difficultyHeader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(data: Cuisine, section: DifficultySection) {
        cuisineImageView.loadImage(url: data.imageURL ?? "")
        nameLabel.text = "\(data.flagEmoji ?? "") \(data.name ?? "")"
        descriptionLabel.text = data.description
        difficultyHeader.configure(data: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
