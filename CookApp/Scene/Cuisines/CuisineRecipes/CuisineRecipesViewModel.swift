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
        configureDataBaseManager()
    }
    
    private let dataBaseManager = RecipeDataBaseManager()
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: State = .idle {
        didSet {
            stateChanged?()
        }
    }

    func getCuisineRecipes() {
        state = .loading
        
        manager.getCuisineRecipes(id: cuisine.id ?? 0) { data, errorMessage in
            if let errorMessage {
                self.state = .error(errorMessage)
            } else if let data {
                self.sections = Difficulty.allCases.compactMap({ difficultyLevel in
                    let recipes = data.filter({ $0.difficulty == difficultyLevel.rawValue })
                    return recipes.isEmpty ? nil : DifficultySection(difficultyLevel: difficultyLevel, recipes: recipes)
                })
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
