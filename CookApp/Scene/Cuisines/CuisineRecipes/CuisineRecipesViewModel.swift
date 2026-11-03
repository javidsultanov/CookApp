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
    var savedIDs: [Int] = []
    
    init(manager: RecipeManagerUseCase = RecipeManager(), cuisine: Cuisine) {
        self.manager = manager
        self.cuisine = cuisine
        configureDataBaseManager()
    }
    
    private let dataBaseManager = RecipeDataBaseManager()
    
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
