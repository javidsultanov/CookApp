//
//  CuisineManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import Foundation

class CuisineManager: CuisineManagerUseCase {
    let manager = CoreManager()
    
    func getCuisines(completion: @escaping ([Cuisine]?, String?) -> Void) {
        manager.request(model: [Cuisine].self, endpoint: CuisineEndpoint.cuisineList.path, completion: completion)
    }
}
