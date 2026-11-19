//
//  RecipeManagerUseCase.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

protocol RecipeManagerUseCase {
//    func getCuisineRecipes(id: Int, completion: @escaping([RecipeCard]?, String?) -> Void)
    func getCuisineRecipes(id: Int) async throws -> [RecipeCard]
//    func getRecipes(cuisinesID: [Int], completion: @escaping([RecipeCard]?, String?) -> Void)
    func getRecipes(cuisinesID: [Int]) async throws -> [RecipeCard]
//    func getRecipeDetails(id: Int, completion: @escaping([RecipeDetail]?, String?) -> Void)
    func getRecipeDetails(id: Int) async throws -> [RecipeDetail]
}
