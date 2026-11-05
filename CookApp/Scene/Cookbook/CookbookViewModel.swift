//
//  CookbookViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 02.11.26.
//

import Foundation

final class CookbookViewModel {
    var recipes: [RecipeEntity] = []
    
    private let manager = RecipeDataBaseManager()
    
    init() {
        configureDataBaseManager()
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getRecipes() {
        manager.getRecipes()
    }
    
    func deleteRecipes(recipeID: Int) {
        manager.deleteRecipe(recipeID: recipeID)
    }
    
    private func configureDataBaseManager() {
        manager.fetchCallback = { recipes in
            self.recipes = recipes
            self.success?()
        }
        
        manager.deleteCallback = { recipeID in
            self.recipes.removeAll(where: { Int($0.recipeID) == recipeID })
            self.success?()
        }
        
        manager.errorCallback = { errorMessage in
            self.error?(errorMessage)
        }
    }
}
