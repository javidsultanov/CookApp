//
//  RecipesViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.10.26.
//

import Foundation

final class RecipesViewModel {
    var manager: RecipeManagerUseCase
    var sections: [DifficultySection] = []
    
    init(manager: RecipeManagerUseCase = RecipeManager()) {
        self.manager = manager
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getRecipes() {
        manager.getRecipes(cuisinesID: UserDefaultsHelper.shared.favoriteCuisinesID) { data, errorMessage in
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
