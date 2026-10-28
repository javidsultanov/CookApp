//
//  IngredientRecipesViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.10.26.
//

import Foundation

final class IngredientRecipesViewModel {
    var manager: IngredientManagerUseCase
    let ingredient: Ingredient
    var recipes: [RecipeCard] = []
    
    init(manager: IngredientManagerUseCase = IngredientManager(), ingredient: Ingredient) {
        self.manager = manager
        self.ingredient = ingredient
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getIngredientRecipes() {
        manager.getIngredientRecipes(id: ingredient.id ?? 0) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.recipes = data.compactMap({ $0.recipe })
                self.success?()
            }
        }
    }
}
