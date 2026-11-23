//
//  RecipeInfoHeader.swift
//  CookApp
//
//  Created by Javid Sultanov on 06.11.26.
//

import UIKit

class RecipeInfoHeader: UICollectionReusableView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.backgroundColor = .atlasPeach
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .atlasDark
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .atlasGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var difficultyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .atlasDark
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailHeader: DetailTitleHeader = {
        let header = DetailTitleHeader()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(infoLabel)
        addSubview(difficultyLabel)
        addSubview(descriptionLabel)
        addSubview(detailHeader)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 260),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            difficultyLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 8),
            difficultyLabel.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            
            detailHeader.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailHeader.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailHeader.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailHeader.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    func configure(data: RecipeDetail) {
        imageView.loadImage(url: data.imageURL ?? "")
        titleLabel.text = data.title
        infoLabel.text = "\(data.cuisine?.flagEmoji ?? "") \(data.cuisine?.name ?? "") · \(data.category ?? "") · \(data.cookTimeMinutes ?? 0) minutes · \(data.servings ?? 0) servings"
        
        difficultyLabel.text = data.difficultyText
        difficultyLabel.textColor = data.difficultyColor
        descriptionLabel.text = data.description
        detailHeader.configure(title: "Ingredients", count: "for \(data.servings ?? 0) servings")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
