//
//  RecipeEndpoint.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

enum RecipeEndpoint {
    case cuisineRecipes(id: Int)
    
    var path: String {
        switch self {
        case .cuisineRecipes(let id):
            return CoreHelper.shared.configureURL(endpoint: "recipe_cards?cuisine_id=eq.\(id)&order=difficulty_level,title")
        }
    }
}
