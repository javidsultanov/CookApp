//
//  DiscoverViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 20.11.26.
//

import Foundation
import Observation

@Observable
final class DiscoverViewModel {
    var cuisineManager: CuisineManagerUseCase
    var recipeManager: RecipeManagerUseCase
    
    var cuisines: [Cuisine] = []
    var recipes: [RecipeCard] = []
    var favoriteCuisinesID: [Int] = []
    var recommendedCategory = ""
        
    private(set) var state: ViewState = .idle
    
    var showError = false
    
    init(cuisineManager: CuisineManagerUseCase = CuisineManager(),
         recipeManager: RecipeManagerUseCase = RecipeManager()) {
        self.cuisineManager = cuisineManager
        self.recipeManager = recipeManager
    }
    
    var favoriteCuisines: [Cuisine] {
        if favoriteCuisinesID.isEmpty {
            return cuisines
        }
        
        return cuisines.filter({ favoriteCuisinesID.contains($0.id ?? 0) })
    }
    
    var pickedRecipes: [RecipeCard] {
        let featuredRecipes = recipes.filter({ $0.isFeatured == true })
        return Array((featuredRecipes.isEmpty ? recipes : featuredRecipes).prefix(10))
    }
    
    var recommendedRecipes: [RecipeCard] {
        Array(recipes.filter({ $0.category == recommendedCategory }).prefix(5))
    }
    
    func newRecommendedRecipes() {
        recommendedCategory = recipes.compactMap({ $0.category }).randomElement() ?? ""
    }
    
    func getDiscoverData() async {
        favoriteCuisinesID = UserDefaultsHelper.shared.favoriteCuisinesID
        state = .loading
        
        do {
            let cuisineData = try await cuisineManager.getCuisines()
            cuisines = cuisineData
            
            let recipeData = try await recipeManager.getRecipes(cuisinesID: favoriteCuisinesID)
            recipes = recipeData
            
            recommendedCategory = recipes.compactMap({ $0.category }).randomElement() ?? ""
            
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
            showError = true
        }
    }
}
