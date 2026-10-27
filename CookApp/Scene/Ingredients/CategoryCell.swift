//
//  CategoryCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 26.10.26.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "CategoryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 16
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        contentView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(category: String, selected: Bool) {
        categoryLabel.text = category
        
        if selected {
            contentView.backgroundColor = .atlasOrange
            categoryLabel.textColor = .white
        } else {
            contentView.backgroundColor = .white
            categoryLabel.textColor = .atlasDark
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
