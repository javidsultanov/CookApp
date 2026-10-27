//
//  CuisineRecipesCoordinator.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation
import UIKit

class CuisineRecipesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var cuisine: Cuisine
    
    init(navigationController: UINavigationController, cuisine: Cuisine) {
        self.navigationController = navigationController
        self.cuisine = cuisine
    }
    
    func start() {
        let controller = CuisineRecipesController(viewModel: .init(cuisine: cuisine))
        navigationController.show(controller, sender: nil)
    }
}
