//
//  AIHelpViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.11.26.
//

import Foundation
import Observation

@Observable
final class AIHelpViewModel {
    var aiManager: AIManagerUseCase
    var ingredientManager: IngredientManagerUseCase
    
    init(aiManager: AIManagerUseCase = AIManager(), ingredientManager: IngredientManagerUseCase = IngredientManager()) {
        self.aiManager = aiManager
        self.ingredientManager = ingredientManager
        
        if aiManager.isAvailable {
            viewState = .loaded
        } else {
            viewState = .error("AI Help needs an iPhone with Apple Intelligence turned on.")
        }
    }
    
    var ingredients: [Ingredient] = []
    var recipes: [RecipeCard] = []
    var picks: [RecipePicker] = []
    var sampleNames: [String] = []
    var text = ""
    var maxMinutes = 40
    
    private(set) var viewState: ViewState = .idle
    private(set) var resultState: ViewState = .idle
    
    var showError = false
    
    func recipe(id: Int) -> RecipeCard? {
        recipes.first(where: { $0.id == id })
    }
    
    func getAIHelp() async {
        guard !text.isEmpty else { return }
        resultState = .loading
        recipes = []
        picks = []
        sampleNames = []
        
        do {
            if ingredients.isEmpty {
                ingredients = try await ingredientManager.getIngredients()
            }
            
            let catalog = ingredients.compactMap({ $0.name })
            
            let names = try await aiManager.handleIngredients(text: text, catalog: catalog)
            sampleNames = names
            let lowerNames = names.map({ $0.lowercased() })
            
            let ids = ingredients.filter({ lowerNames.contains(($0.name ?? "").lowercased()) }).compactMap({ $0.id })
            guard !ids.isEmpty else {
                resultState = .loaded
                return
            }
            
            let rows = try await ingredientManager.getRecipesWithIngredients(ids: ids)
            for row in rows {
                if (row.cookTimeMinutes ?? 0) <= maxMinutes && recipe(id: row.id ?? 0) == nil {
                    recipes.append(row)
                }
            }
            
            guard !recipes.isEmpty else {
                resultState = .loaded
                return
            }
            
            let aiPicks = try await aiManager.pickRecipes(text: text, recipes: recipes)
            picks = aiPicks.filter({ recipe(id: $0.recipeID) != nil })
            
            resultState = .loaded
        } catch {
            resultState = .error(error.localizedDescription)
            showError = true
        }
    }
}
