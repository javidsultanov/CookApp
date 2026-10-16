//
//  WelcomeCell.swift
//  CookApp
//
//  Created by Javid Sultanov on 14.10.26.
//

import UIKit

class WelcomeCell: UICollectionViewCell {
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 253/255, green: 230/255, blue: 209/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "🥘"
        label.font = UIFont.systemFont(ofSize: 120, weight: .regular)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "CookAtlas")
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor(red: 42/255, green: 31/255, blue: 23/255, alpha: 1),
                                    range: NSRange(location: 0, length: 4))
        attributedText.addAttribute(.foregroundColor,
                                    value: UIColor(red: 236/255, green: 111/255, blue: 26/255, alpha: 1),
                                    range: NSRange(location: 4, length: 5))
        
        label.attributedText = attributedText
        label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "WORLD CUISINES & RECIPES"
        label.textColor = UIColor(red: 236/255, green: 111/255, blue: 26/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Saw a dish you'd love to try? Find the recipe, check the ingredients and cook it at home, step by step."
        label.textColor = UIColor(red: 110/255, green: 96/255, blue: 84/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    static let identifier = "WelcomeCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        contentView.addSubview(emojiView)
        emojiView.addSubview(emojiLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            emojiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            emojiView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.88),
            emojiView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.52),
            
            emojiLabel.topAnchor.constraint(equalTo: emojiView.topAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: emojiView.trailingAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: emojiView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: emojiView.leadingAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: emojiView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
