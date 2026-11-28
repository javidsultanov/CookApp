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
    
    var allCuisines: [Cuisine] = []
    
    init(manager: CuisineManagerUseCase = CuisineManager()) {
        self.manager = manager
    }
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }
    
    func getCuisines() {
        state = .loading
        
        Task {
            do {
                let data = try await manager.getCuisines()
                allCuisines = data
                sortCuisines()
                
                state = .loaded
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func sortCuisines() {
        let favoriteCuisines = allCuisines.filter({ isFavorite(cuisine: $0) })
        let otherCuisines = allCuisines.filter({ !isFavorite(cuisine: $0) })
        cuisines = favoriteCuisines + otherCuisines
    }
    
    func isFavorite(cuisine: Cuisine) -> Bool {
        UserDefaultsHelper.shared.favoriteCuisinesID.contains(cuisine.id ?? 0)
    }
}
