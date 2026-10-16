//
//  CuisineManagerUseCase.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import Foundation

protocol CuisineManagerUseCase {
    func getCuisines(completion: @escaping ([Cuisine]?, String?) -> Void)
}
