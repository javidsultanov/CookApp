//
//  IngredientManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.10.26.
//

import Foundation

class IngredientManager: IngredientManagerUseCase {
    let manager = CoreManager()
    
    func getIngredients(completion: @escaping ([Ingredient]?, String?) -> Void) {
        manager.request(model: [Ingredient].self, endpoint: IngredientEndpoint.ingredientList.path, completion: completion)
    }
    
    func getIngredientRecipes(id: Int, completion: @escaping ([RecipeCard]?, String?) -> Void) {
        manager.request(model: [RecipeCard].self, endpoint: IngredientEndpoint.ingredientRecipes(id: id).path, completion: completion)
    }
}
