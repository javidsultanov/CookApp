//
//  CuisineCardCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import UIKit

class CuisineCardCell: UICollectionViewCell {
    private lazy var cuisineImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .atlasPeach
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "❣️Favorite "
        label.textColor = .atlasOrange
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.backgroundColor = .white
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .atlasDark
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .atlasGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "CuisineCardCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configureConstraints()
    }
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func configureConstraints() {
        contentView.addSubview(cuisineImageView)
        contentView.addSubview(favoriteLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            cuisineImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cuisineImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cuisineImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cuisineImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.64),
            
            favoriteLabel.topAnchor.constraint(equalTo: cuisineImageView.topAnchor, constant: 8),
            favoriteLabel.leadingAnchor.constraint(equalTo: cuisineImageView.leadingAnchor, constant: 8),
            favoriteLabel.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: cuisineImageView.leadingAnchor, constant: 8),
            
            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    func configure(data: Cuisine, isFavorite: Bool) {
        cuisineImageView.image = nil
        cuisineImageView.loadImage(url: data.imageURL ?? "")
        
        nameLabel.text = "\(data.flagEmoji ?? "") \(data.name ?? "")"
        infoLabel.text = "\(data.region ?? "") \(data.recipeCount ?? 0) recipes"
        favoriteLabel.isHidden = !isFavorite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
