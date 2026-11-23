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
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }
    
    func getCuisines() {
        state = .loading
        
//        manager.getCuisines { data, errorMessage in
//            if let errorMessage {
//                self.state = .error(errorMessage)
//            } else if let data {
//                let favoriteCuisines = data.filter({ self.isFavorite(cuisine: $0) })
//                let otherCuisines = data.filter({ !self.isFavorite(cuisine: $0) })
//                self.cuisines = favoriteCuisines + otherCuisines
//                self.state = .loaded
//            }
//        }
        
        Task {
            do {
                let data = try await manager.getCuisines()
                let favoriteCuisines = data.filter({ isFavorite(cuisine: $0) })
                let otherCuisines = data.filter({ !isFavorite(cuisine: $0) })
                cuisines = favoriteCuisines + otherCuisines
                
                state = .loaded
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func isFavorite(cuisine: Cuisine) -> Bool {
        UserDefaultsHelper.shared.favoriteCuisinesID.contains(cuisine.id ?? 0)
    }
}
