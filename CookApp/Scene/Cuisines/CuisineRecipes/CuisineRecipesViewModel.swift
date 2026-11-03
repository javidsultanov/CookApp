//
//  CuisineRecipesViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

final class CuisineRecipesViewModel {
    var manager: RecipeManagerUseCase
    let cuisine: Cuisine
    var sections: [DifficultySection] = []
    
    init(manager: RecipeManagerUseCase = RecipeManager(), cuisine: Cuisine) {
        self.manager = manager
        self.cuisine = cuisine
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getCuisineRecipes() {
        manager.getCuisineRecipes(id: cuisine.id ?? 0) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.sections = Difficulty.allCases.compactMap({ difficultyLevel in
                    let recipes = data.filter({ $0.difficulty == difficultyLevel.rawValue })
                    return recipes.isEmpty ? nil : DifficultySection(difficultyLevel: difficultyLevel, recipes: recipes)
                })
                self.success?()
            }
        }
    }
}
