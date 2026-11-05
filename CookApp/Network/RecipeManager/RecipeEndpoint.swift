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
    case recipeDetail(id: Int)
    
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
        case .recipeDetail(id: let id):
            return CoreHelper.shared.configureURL(endpoint: "recipes?select=id,title,description,category,difficulty,cook_time_minutes,servings,instructions,image_url,youtube_url,cuisine:cuisines(id,name,flag_emoji),ingredients:recipe_ingredients(measure,position,ingredient:ingredients(id,name,category,image_url))&id=eq.\(id)&ingredients.order=position")
        }
    }
}
