//
//  UILabel+AppFont.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.11.26.
//

import Foundation
import UIKit

extension UILabel {
    func apply(_ font: AppFont, color: UIColor) {
        self.font = font.uiFont
        textColor = color
    }
}
