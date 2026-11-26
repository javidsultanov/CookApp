//
//  AIManagerUseCase.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.11.26.
//

import Foundation

protocol AIManagerUseCase {
    var isAvailable: Bool { get }
    func handleIngredients(text: String, catalog: [String]) async throws -> [String]
    func pickRecipes(text: String, recipes: [RecipeCard]) async throws -> [RecipePicker]
}
