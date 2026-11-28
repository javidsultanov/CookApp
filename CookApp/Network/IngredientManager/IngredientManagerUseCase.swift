//
//  IngredientManagerUseCase.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.10.26.
//

import Foundation

protocol IngredientManagerUseCase {
    func getIngredients() async throws -> [Ingredient]
    func getIngredientRecipes(id: Int) async throws -> [RecipeCard]
    func getRecipesWithIngredients(ids: [Int]) async throws -> [RecipeCard]
}
