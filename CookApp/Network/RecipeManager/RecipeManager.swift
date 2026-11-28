//
//  RecipeManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

struct RecipeManager: RecipeManagerUseCase {
    let manager = CoreManager()
    
    func getCuisineRecipes(id: Int) async throws -> [RecipeCard] {
        try await manager.request(model: [RecipeCard].self, endpoint: RecipeEndpoint.cuisineRecipes(id: id).path)
    }
    
    func getRecipes(cuisinesID: [Int]) async throws -> [RecipeCard] {
        try await manager.request(model: [RecipeCard].self, endpoint: RecipeEndpoint.recipeList(cuisinesID: cuisinesID).path)
    }
    
    func getRecipeDetails(id: Int) async throws -> [RecipeDetail] {
        try await manager.request(model: [RecipeDetail].self, endpoint: RecipeEndpoint.recipeDetail(id: id).path)
    }
}
