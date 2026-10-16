//
//  UIImageView+Extension.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(url: String) {
        guard let url = URL(string: url) else { return }
        kf.indicatorType = .activity
        kf.setImage(with: url)
    }
}
