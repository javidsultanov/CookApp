//
//  CuisineEndpoint.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import Foundation

enum CuisineEndpoint {
    case cuisineList
    
    var path: String {
        switch self {
            case .cuisineList:
            return CoreHelper.shared.configureURL(endpoint: "cuisine_list?order=name")
        }
    }
}
