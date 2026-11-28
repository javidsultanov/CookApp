//
//  IngredientsViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.10.26.
//

import Foundation

final class IngredientsViewModel {
    var manager: IngredientManagerUseCase
    
    init(manager: IngredientManagerUseCase = IngredientManager()) {
        self.manager = manager
    }
    
    var ingredients: [Ingredient] = []
    var filteredIngredients: [Ingredient] = []
    var categories: [String] = []
    var selectedCategoryIndex: Int?
    var searchText = ""
        
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }

    func getIngredients() {
        state = .loading
        
        Task {
            do {
                let data = try await manager.getIngredients()
                ingredients = data
                filteredIngredients = data
                
                categories = []
                for ingredient in data {
                    if let category = ingredient.category, !categories.contains(category) {
                        categories.append(category)
                    }
                }
                categories.sort()
                
                state = .loaded
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func filterIngredients() {
        var category: String?
        if let selectedCategoryIndex {
            category = categories[selectedCategoryIndex]
        }
        
        filteredIngredients = ingredients.filter({
            (category == nil || $0.category == category) &&
            (searchText.isEmpty || ($0.name ?? "").lowercased().contains(searchText.lowercased()))
        })
    }
}
