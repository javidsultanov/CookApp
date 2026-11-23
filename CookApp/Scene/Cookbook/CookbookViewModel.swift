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
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }
    
    func getRecipes() {
        state = .loading
        recipes = manager.getSavedRecipes()
        state = .loaded
    }
    
    func deleteRecipes(recipeID: Int) {
        manager.deleteRecipe(recipeID: recipeID)
    }
    
    private func configureDataBaseManager() {
        manager.deleteCallback = { recipeID in
            self.recipes.removeAll(where: { Int($0.recipeID) == recipeID })
            self.stateChanged?()
        }
        
        manager.errorCallback = { errorMessage in
            self.state = .error(errorMessage)
        }
    }
}
