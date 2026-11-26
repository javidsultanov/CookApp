//
//  AIManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.11.26.
//

import Foundation
import FoundationModels

struct AIManager: AIManagerUseCase {
    var isAvailable: Bool {
        SystemLanguageModel.default.isAvailable
    }
    
    func handleIngredients(text: String, catalog: [String]) async throws -> [String] {
        let session = LanguageModelSession(instructions: "Pick ingredient names only from the catalog. Write each name exactly as in the catalog.")
        let prompt = "Catalog: \(catalog.joined(separator: ", "))\nThe user has: \(text)"
        
        let response = try await session.respond(to: prompt, generating: IngredientsHandler.self)
        return response.content.names
    }
    
    func pickRecipes(text: String, recipes: [RecipeCard]) async throws -> [RecipePicker] {
        let session = LanguageModelSession(instructions: "Choose recipes only from the list. Explain each choice in one short sentence.")
        let list = recipes.map({ "\($0.id ?? 0): \($0.title ?? "")" }).joined(separator: "\n")
        let prompt = "The user has: \(text)\nRecipes:\n\(list)"
        
        let response = try await session.respond(to: prompt, generating: RecipeFavourite.self)
        return response.content.picks
    }
}
