//
//  IngredientManagerUseCase.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.10.26.
//

import Foundation

protocol IngredientManagerUseCase {
    func getIngredients(completion: @escaping(([Ingredient]?, String?) -> Void))
    func getIngredientRecipes(id: Int, completion: @escaping(([IngredientRecipe]?, String?) -> Void))
}
