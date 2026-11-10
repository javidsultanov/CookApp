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
    
    private(set) var state: State = .idle {
        didSet {
            stateChanged?()
        }
    }

    func getIngredients() {
        state = .loading
        
        manager.getIngredients { data, errorMessage in
            if let errorMessage {
                self.state = .error(errorMessage)
            } else if let data {
                self.ingredients = data
                self.filteredIngredients = data
                
                self.categories = []
                for ingredient in data {
                    if let category = ingredient.category, !self.categories.contains(category) {
                        self.categories.append(category)
                    }
                }
                self.categories.sort()
                
                self.state = .loaded
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
