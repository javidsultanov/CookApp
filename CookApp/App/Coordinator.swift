//
//  Coordinator.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
