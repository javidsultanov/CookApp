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
    var savedIDs: [Int] = []
    
    init(manager: IngredientManagerUseCase = IngredientManager(), ingredient: Ingredient) {
        self.manager = manager
        self.ingredient = ingredient
        configureDataBaseManager()
    }
    
    private let dataBaseManager = RecipeDataBaseManager()
    
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
