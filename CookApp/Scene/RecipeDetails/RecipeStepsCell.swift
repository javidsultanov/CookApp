//
//  RecipeStepsCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 06.11.26.
//

import UIKit

class RecipeStepsCell: UICollectionViewCell {
    private lazy var stepLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .atlasDark
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
        configureConstraints()
    }
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
    }
    
    private func configureConstraints() {
        contentView.addSubview(stepLabel)
        
        NSLayoutConstraint.activate([
            stepLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stepLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stepLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    func configure(step: String) {
        stepLabel.text = step
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
