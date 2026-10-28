//
//  CuisineRecipesCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import UIKit

class CuisineRecipesCell: UICollectionViewCell {
    private lazy var recipeImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.backgroundColor = .atlasPeach
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .atlasDark
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .atlasGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "CuisineRecipesCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configureConstraints()
    }
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
    }
    
    private func configureConstraints() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            recipeImageView.widthAnchor.constraint(equalToConstant: 72),
            recipeImageView.heightAnchor.constraint(equalToConstant: 72),
            
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: 12),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
    
    func configure(data: RecipeCard, showCuisine: Bool = false) {
        recipeImageView.image = nil
        recipeImageView.loadImage(url: data.imageURL ?? "")
        
        titleLabel.text = data.title
        
        if showCuisine {
            infoLabel.text = "\(data.flagEmoji ?? "") \(data.cuisineName ?? "") · \(data.cookTimeMinutes ?? 0) minutes · \(data.ingredientCount ?? 0) ingredients"
        } else {
            infoLabel.text = "\(data.category ?? "") · \(data.cookTimeMinutes ?? 0) minutes · \(data.ingredientCount ?? 0) ingredients"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
