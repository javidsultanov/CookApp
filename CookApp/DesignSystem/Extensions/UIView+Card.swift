//
//  UIView+Card.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.11.26.
//

import Foundation
import UIKit

extension UIView {
    func applyCardStyle(radius: CGFloat = AppRadius.xl) {
        backgroundColor = .white
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
