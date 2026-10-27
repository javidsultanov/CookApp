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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .atlasGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "DifficultyHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        addSubview(titleLabel)
        addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            countLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func configure(data: DifficultySection) {
        titleLabel.text = data.difficultyLevel.rawValue
        titleLabel.textColor = data.difficultyLevel.color
        countLabel.text = data.recipes.count == 1 ? "1 recipe" : "\(data.recipes.count) recipes"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
