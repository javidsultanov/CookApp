//
//  UIActivityIndicatorView+Extension.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import Foundation
import UIKit

extension UIActivityIndicatorView {
    static func loadingView() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .atlasOrange
        view.hidesWhenStopped = true
        return view
    }
}
