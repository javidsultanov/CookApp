//
//  DifficultyHeader.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import UIKit

class DifficultyHeader: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.apply(.sectionTitle, color: .atlasDark)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.apply(.caption, color: .atlasGray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "Showing recipes from your favorite cuisines. Want more? Choose more cuisines in Settings."
        label.apply(.headline, color: .atlasGray)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        addSubview(hintLabel)
        addSubview(titleLabel)
        addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hintLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            hintLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            countLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
    }
    
    func configure(data: DifficultySection, hint: String? = nil) {
        titleLabel.text = data.difficultyLevel.rawValue
        titleLabel.textColor = data.difficultyLevel.color
        countLabel.text = data.recipes.count == 1 ? "1 recipe" : "\(data.recipes.count) recipes"
        
        hintLabel.text = hint
        hintLabel.isHidden = hint == nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
