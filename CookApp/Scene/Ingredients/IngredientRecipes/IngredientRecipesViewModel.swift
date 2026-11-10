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
        configureDataBaseManager()
    }
    
    private let dataBaseManager = RecipeDataBaseManager()
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: State = .idle {
        didSet {
            stateChanged?()
        }
    }
    
    func getIngredientRecipes() {
        state = .loading
        
        manager.getIngredientRecipes(id: ingredient.id ?? 0) { data, errorMessage in
            if let errorMessage {
                self.state = .error(errorMessage)
            } else if let data {
                self.recipes = data
                self.state = .loaded
            }
        }
    }
        
    func isSaved(recipe: RecipeCard) -> Bool {
        dataBaseManager.isSaved(recipeID: recipe.id ?? 0)
    }
    
    func saveButtonTapped(recipe: RecipeCard) {
        if isSaved(recipe: recipe) {
            dataBaseManager.deleteRecipe(recipeID: recipe.id ?? 0)
        } else {
            dataBaseManager.saveRecipe(recipe: recipe)
        }
    }
    
    func configureDataBaseManager() {
        dataBaseManager.saveCallback = { recipe in
            self.stateChanged?()
        }
        
        dataBaseManager.deleteCallback = { recipeID in
            self.stateChanged?()
        }
        
        dataBaseManager.errorCallback = { errorMessage in
            self.state = .error(errorMessage)
        }
    }
}
