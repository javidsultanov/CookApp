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
        configureDataBaseManager()
    }
    
    private let dataBaseManager = RecipeDataBaseManager()
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }
    
    func getRecipes() {
        state = .loading
        
        manager.getRecipes(cuisinesID: UserDefaultsHelper.shared.favoriteCuisinesID) { data, errorMessage in
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
