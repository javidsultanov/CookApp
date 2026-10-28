//
//  RecipeEndpoint.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

enum RecipeEndpoint {
    case cuisineRecipes(id: Int)
    case recipeList(cuisinesID: [Int])
    
    var path: String {
        switch self {
        case .cuisineRecipes(let id):
            return CoreHelper.shared.configureURL(endpoint: "recipe_cards?cuisine_id=eq.\(id)&order=difficulty_level,title")
        case .recipeList(let cuisinesID):
            if cuisinesID.isEmpty {
                return CoreHelper.shared.configureURL(endpoint: "recipe_cards?order=difficulty_level,title")
            }
            
            let ids = cuisinesID.map({ "\($0)" }).joined(separator: ",")
            return CoreHelper.shared.configureURL(endpoint: "recipe_cards?cuisine_id=in.(\(ids))&order=difficulty_level,title")
        }
    }
}
