//
//  RecipesViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.10.26.
//

import Foundation

final class RecipesViewModel {
    var manager: RecipeManagerUseCase
    
    init(manager: RecipeManagerUseCase = RecipeManager()) {
        self.manager = manager
        configureDataBaseManager()
    }
    
    var sections: [DifficultySection] = []
    
    private let dataBaseManager = RecipeDataBaseManager()
    private var loadedCuisinesID: [Int]?
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }
    
    func getRecipes() {
        let cuisinesID = UserDefaultsHelper.shared.favoriteCuisinesID
        guard cuisinesID != loadedCuisinesID else { return }
        state = .loading
                
        Task {
            do {
                let data = try await manager.getRecipes(cuisinesID: UserDefaultsHelper.shared.favoriteCuisinesID)
                sections = Difficulty.allCases.compactMap({ difficultyLevel in
                    let recipes = data.filter({ $0.difficulty == difficultyLevel.rawValue })
                    return recipes.isEmpty ? nil : DifficultySection(difficultyLevel: difficultyLevel, recipes: recipes)
                })
                loadedCuisinesID = cuisinesID
                
                state = .loaded
            } catch {
                state = .error(error.localizedDescription)
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
