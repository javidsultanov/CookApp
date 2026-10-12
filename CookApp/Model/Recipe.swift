//
//  Recipe.swift
//  CookApp
//
//  Created by Javid Sultanov on 12.10.26.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let recipe = try? JSONDecoder().decode(Recipe.self, from: jsonData)

import Foundation
import UIKit

// MARK: - RecipeCard
struct RecipeCard: Codable, DifficultyProtocol {
    let id: Int?
    let title: String?
    let slug: String?
    let description: String?
    let category: String?
    let cookTimeMinutes: Int?
    let servings: Int?
    let difficulty: String?
    let difficultyLevel: Int?
    let isFeatured: Bool?
    let imageURL: String?
    let cuisineID: Int?
    let cuisineName: String?
    let flagEmoji: String?
    let ingredientCount: Int?
    
    var difficultyText: String {
        difficulty ?? ""
    }
    
    var difficultyColor: UIColor {
        Difficulty(rawValue: difficulty ?? "")?.color ?? .systemGray
    }

    enum CodingKeys: String, CodingKey {
        case id, title, slug, description, category, servings, difficulty
        case cookTimeMinutes = "cook_time_minutes"
        case difficultyLevel = "difficulty_level"
        case isFeatured = "is_featured"
        case imageURL = "image_url"
        case cuisineID = "cuisine_id"
        case cuisineName = "cuisine_name"
        case flagEmoji = "flag_emoji"
        case ingredientCount = "ingredient_count"
    }
}

// MARK: - RecipeDetail
struct RecipeDetail: Codable, DifficultyProtocol {
    let id: Int?
    let title: String?
    let description: String?
    let category: String?
    let difficulty: String?
    let cookTimeMinutes: Int?
    let servings: Int?
    let instructions: String?
    let imageURL: String?
    let youtubeURL: String?
    let ingredients: [RecipeIngredient]?
    let cuisine: CuisineInfo?
    
    var difficultyText: String {
        difficulty ?? ""
    }
    
    var difficultyColor: UIColor {
        Difficulty(rawValue: difficulty ?? "")?.color ?? .systemGray
    }
    
    var steps: [String] {
        instructions?.components(separatedBy: "\n") ?? []
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, category, difficulty, servings, instructions, ingredients, cuisine
        case cookTimeMinutes = "cook_time_minutes"
        case imageURL = "image_url"
        case youtubeURL = "youtube_url"
    }
}

// MARK: - CuisineInfo
struct CuisineInfo: Codable {
    let id: Int?
    let name: String?
    let flagEmoji: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case flagEmoji = "flag_emoji"
    }
}

// MARK: - RecipeIngredient
struct RecipeIngredient: Codable {
    let measure: String?
    let position: Int?
    let ingredient: Ingredient?

    enum CodingKeys: String, CodingKey {
        case measure, position, ingredient
    }
}
