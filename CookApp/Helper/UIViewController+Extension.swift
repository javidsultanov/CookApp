//
//  UIViewController+Extension.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import Foundation
import UIKit

extension UIViewController {
    func showDefaultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        
        self.present(alert, animated: true)
    }
}
