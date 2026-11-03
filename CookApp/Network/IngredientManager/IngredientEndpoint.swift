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
            return CoreHelper.shared.configureURL(endpoint: "ingredients?select=id,name,category,image_url,recipe_ingredients(count)&order=name")
        case .ingredientRecipes(let id):
            return CoreHelper.shared.configureURL(endpoint: "recipe_ingredients?select=recipe:recipe_cards(*)&ingredient_id=eq.\(id)")
        }
    }
}
