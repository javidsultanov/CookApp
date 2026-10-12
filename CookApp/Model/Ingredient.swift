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

// MARK: - Ingredient
struct Ingredient: Codable {
    let id: Int?
    let name: String?
    let category: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, category
        case imageURL = "image_url"
    }
}
