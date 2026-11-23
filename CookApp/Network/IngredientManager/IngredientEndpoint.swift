//
//  IngredientEndpoint.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.10.26.
//

import Foundation

enum IngredientEndpoint {
    case ingredientList
    case ingredientRecipes(id: Int)
    
    var path: String {
        switch self {
        case .ingredientList:
            return CoreHelper.shared.configureURL(endpoint: "ingredient_list?order=name")
        case .ingredientRecipes(let id):
            return CoreHelper.shared.configureURL(endpoint: "ingredient_recipes?ingredient_id=eq.\(id)&order=difficulty_level,title")
        }
    }
}
