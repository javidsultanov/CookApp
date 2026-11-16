//
//  SettingViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 11.11.26.
//

import Foundation
import Observation

@Observable
final class SettingViewModel {
    var manager: CuisineManagerUseCase
    
    init(manager: CuisineManagerUseCase = CuisineManager()) {
        self.manager = manager
    }
    
    var cuisines: [Cuisine] = []
    var favoriteCuisinesID: [Int] = UserDefaultsHelper.shared.favoriteCuisinesID
    var savedCount = 0
    
    private(set) var state: ViewState = .idle
    
    var showError = false
    
    var recipeCount: Int {
        var count = 0
        
        for cuisine in cuisines {
            count += cuisine.recipeCount ?? 0
        }
        return count
    }
    
    var savedText: String {
        if savedCount == 1 {
            return "1 saved recipe"
        }
        
        return "\(savedCount) saved recipes"
    }
    
    func getCuisines() {
        state = .loading
        
        manager.getCuisines { data, errorMessage in
            if let errorMessage {
                self.state = .error(errorMessage)
                self.showError = true
            } else if let data {
                self.cuisines = data
                self.state = .loaded
            }
        }
    }
    
    func getSavedCount() {
        savedCount = RecipeDataBaseManager().getSavedRecipes().count
    }
    
    func isFavorite(cuisine: Cuisine) -> Bool {
        guard let id = cuisine.id else { return false }
        return favoriteCuisinesID.contains(id)
    }
    
    func toggleFavorite(cuisine: Cuisine) {
        guard let id = cuisine.id else { return }
        
        if favoriteCuisinesID.contains(id) {
            favoriteCuisinesID.removeAll(where: { $0 == id })
        } else {
            favoriteCuisinesID.append(id)
        }
        
        UserDefaultsHelper.shared.favoriteCuisinesID = favoriteCuisinesID
    }
}
