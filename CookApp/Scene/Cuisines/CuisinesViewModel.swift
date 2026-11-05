//
//  CuisinesViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 23.10.26.
//

import Foundation

final class CuisinesViewModel {
    var manager: CuisineManagerUseCase
    var cuisines: [Cuisine] = []
    
    init(manager: CuisineManagerUseCase = CuisineManager()) {
        self.manager = manager
    }
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    func getCuisines() {
        manager.getCuisines { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                let favoriteCuisines = data.filter({ self.isFavorite(cuisine: $0) })
                let otherCuisines = data.filter({ !self.isFavorite(cuisine: $0) })
                self.cuisines = favoriteCuisines + otherCuisines
                self.success?()
            }
        }
    }
    
    func isFavorite(cuisine: Cuisine) -> Bool {
        UserDefaultsHelper.shared.favoriteCuisinesID.contains(cuisine.id ?? 0)
    }
}
