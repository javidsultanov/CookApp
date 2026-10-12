//
//  Cuisine.swift
//  CookApp
//
//  Created by Javid Sultanov on 12.10.26.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cuisine = try? JSONDecoder().decode(Cuisine.self, from: jsonData)

import Foundation

// MARK: - Cuisine
struct Cuisine: Codable {
    let id: Int?
    let name: String?
    let countryCode: String?
    let region: String?
    let description: String?
    let slug: String?
    let flagEmoji: String?
    let imageURL: String?
    let flagURL: String?
    let recipeCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, region, description, slug
        case countryCode = "country_code"
        case flagEmoji = "flag_emoji"
        case imageURL = "image_url"
        case flagURL = "flag_url"
        case recipeCount = "recipe_count"
    }
}
