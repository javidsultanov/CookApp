//
//  RecipeManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

struct RecipeManager: RecipeManagerUseCase {
    let manager = CoreManager()
    
    func getCuisineRecipes(id: Int, completion: @escaping ([RecipeCard]?, String?) -> Void) {
        manager.request(model: [RecipeCard].self, endpoint: RecipeEndpoint.cuisineRecipes(id: id).path, completion: completion)
    }
    
    func getRecipes(cuisinesID: [Int], completion: @escaping ([RecipeCard]?, String?) -> Void) {
        manager.request(model: [RecipeCard].self, endpoint: RecipeEndpoint.recipeList(cuisinesID: cuisinesID).path, completion: completion)
    }
}
