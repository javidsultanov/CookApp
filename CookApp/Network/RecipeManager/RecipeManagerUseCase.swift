//
//  RecipeManagerUseCase.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

protocol RecipeManagerUseCase {
    func getCuisineRecipes(id: Int, completion: @escaping([RecipeCard]?, String?) -> Void)
    func getRecipes(cuisinesID: [Int], completion: @escaping([RecipeCard]?, String?) -> Void)
}
