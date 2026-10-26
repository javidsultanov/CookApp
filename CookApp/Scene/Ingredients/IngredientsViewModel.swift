//
//  IngredientsViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.10.26.
//

import Foundation

final class IngredientsViewModel {
    var manager: IngredientManagerUseCase
    var ingredients: [Ingredient] = []
    
    init(manager: IngredientManagerUseCase = IngredientManager()) {
        self.manager = manager
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getIngredients() {
        manager.getIngredients { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.ingredients = data
                self.success?()
            }
        }
    }
}
