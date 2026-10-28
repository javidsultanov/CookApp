//
//  Ingredient.swift
//  CookApp
//
//  Created by Javid Sultanov on 12.10.26.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ingredient = try? JSONDecoder().decode(Ingredient.self, from: jsonData)

import Foundation

protocol IngredientProtocol {
    var imagePath: String { get }
    var titleText: String { get }
    var countText: String { get }
}

// MARK: - Ingredient
struct Ingredient: Codable, IngredientProtocol {
    let id: Int?
    let name: String?
    let category: String?
    let imageURL: String?
    let recipeIngredients: [RecipeCount]?
    
    var imagePath: String {
        imageURL ?? ""
    }
    
    var titleText: String {
        name ?? ""
    }
    
    var countText: String {
        let count = recipeIngredients?.first?.count ?? 0
        return count == 1 ? "1 recipe" : "\(count) recipes"
    }

    enum CodingKeys: String, CodingKey {
        case id, name, category
        case imageURL = "image_url"
        case recipeIngredients = "recipe_ingredients"
    }
}

//MARK: - RecipeCount
struct RecipeCount: Codable {
    let count: Int?
}
