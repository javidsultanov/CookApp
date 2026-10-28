//
//  IngredientRecipesCoordinator.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.10.26.
//

import Foundation
import UIKit

class IngredientRecipesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var ingredient: Ingredient
    
    init(navigationController: UINavigationController, ingredient: Ingredient) {
        self.navigationController = navigationController
        self.ingredient = ingredient
    }
    
    func start() {
        let controller = IngredientRecipesController(viewModel: .init(ingredient: ingredient))
        navigationController.show(controller, sender: nil)
    }
}
