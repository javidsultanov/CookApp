//
//  HomeManager.swift
//  CookApp
//
//  Created by Shamkhal Guliyev on 16.10.26.
//

import Foundation

class HomeManager: HomeUseCase {
    private let manager = CoreManager()
    
    func getHomeItems() {
        manager.request(model: HomeItem.self,
                        endpoint: "hebele hjubele") { data, error in
            
        }
    }
}
