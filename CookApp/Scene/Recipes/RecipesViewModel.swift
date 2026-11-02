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
    var savedIDs: [Int] = []
    
    init(manager: RecipeManagerUseCase = RecipeManager()) {
        self.manager = manager
        configureDataBaseManager()
    }
    
    private let dataBaseManager = RecipeDataBaseManager()
    
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
    
    func getSavedRecipes() {
        dataBaseManager.getRecipes()
    }
    
    func isSaved(recipe: RecipeCard) -> Bool {
        savedIDs.contains(recipe.id ?? 0)
    }
    
    func saveButtonTapped(recipe: RecipeCard) {
        if isSaved(recipe: recipe) {
            dataBaseManager.deleteRecipe(recipeID: recipe.id ?? 0)
        } else {
            dataBaseManager.saveRecipe(recipe: recipe)
        }
    }
    
    func configureDataBaseManager() {
        dataBaseManager.fetchCallback = { recipes in
            self.savedIDs = recipes.map({ Int($0.recipeID) })
            self.success?()
        }
        
        dataBaseManager.saveCallback = { recipe in
            self.savedIDs.append(Int(recipe.recipeID))
            self.success?()
        }
        
        dataBaseManager.deleteCallback = { recipeID in
            self.savedIDs.removeAll (where: { $0 == recipeID })
            self.success?()
        }
        
        dataBaseManager.errorCallback = { errorMessage in
            self.error?(errorMessage)
        }
    }
}
