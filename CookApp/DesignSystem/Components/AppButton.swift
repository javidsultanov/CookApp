//
//  AppButton.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.11.26.
//

import Foundation
import UIKit

final class AppButton: UIButton {
    enum Style {
        case primary
        case secondary
        
        var background: UIColor {
            switch self {
            case .primary: return .atlasOrange
            case .secondary: return .atlasPeach
            }
        }

        var foreground: UIColor {
            switch self {
            case .primary: return .white
            case .secondary: return .atlasOrange
            }
        }
    }

    private let style: Style

    override var isHighlighted: Bool {
        didSet { alpha = isHighlighted ? 0.8 : 1 }
    }

    override var isEnabled: Bool {
        didSet { backgroundColor = isEnabled ? style.background : .atlasSand }
    }

    init(style: Style = .primary, title: String? = nil, systemImage: String? = nil) {
        self.style = style
        super.init(frame: .zero)
        configureUI(title: title, systemImage: systemImage)
    }

    private func configureUI(title: String?, systemImage: String?) {
        setTitle(title, for: .normal)
        setTitleColor(style.foreground, for: .normal)
        titleLabel?.font = AppFont.headline.uiFont
        backgroundColor = style.background
        layer.cornerRadius = AppRadius.l

        if let systemImage {
            setImage(UIImage(systemName: systemImage), for: .normal)
            tintColor = style.foreground
        }

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 52).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
