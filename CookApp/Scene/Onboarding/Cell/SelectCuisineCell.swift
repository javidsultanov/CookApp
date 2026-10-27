//
//  SelectCuisineCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 15.10.26.
//

import UIKit

class SelectCuisineCell: UICollectionViewCell {
    private lazy var cuisineImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .atlasPeach
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var flagEmojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
    
    private lazy var checkmarkImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    static let identifier = "SelectCuisineCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configureConstraints()
    }
    
    private func configureCell() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.layer.borderColor = UIColor.atlasOrange.cgColor
    }
    
    private func configureConstraints() {
        contentView.addSubview(cuisineImageView)
        contentView.addSubview(flagEmojiLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            cuisineImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cuisineImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cuisineImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cuisineImageView.heightAnchor.constraint(equalToConstant: 88),
            
            flagEmojiLabel.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 12),
            flagEmojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            nameLabel.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: flagEmojiLabel.trailingAnchor, constant: 8),
            
            checkmarkImageView.topAnchor.constraint(equalTo: cuisineImageView.bottomAnchor, constant: 12),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(data: Cuisine, selected: Bool) {
        cuisineImageView.image = nil
        cuisineImageView.loadImage(url: data.imageURL ?? "")
        
        flagEmojiLabel.text = data.flagEmoji
        nameLabel.text = data.name
        
        contentView.layer.borderWidth = selected ? 2 : 0
        checkmarkImageView.image = UIImage(systemName: selected ? "checkmark.circle.fill" : "circle")
        checkmarkImageView.tintColor = selected ? .atlasOrange : .atlasSand
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
