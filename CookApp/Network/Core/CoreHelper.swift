//
//  CoreHelper.swift
//  CookApp
//
//  Created by Javid Sultanov on 12.10.26.
//

import Foundation
import Alamofire

class CoreHelper {
    static let shared = CoreHelper()
    
    private init() {}
    
    private let baseURL: String = "https://xiesqgfnqrvtytyvvqdx.supabase.co/"
    private let version: String = "rest/v1"
    
    private let apiKey = "sb_publishable_i6d8zsZ8gkXY6NiKky0FPQ_kmFtrHvx"
    
    var headers: HTTPHeaders {
        [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
    }
    
    func configureURL(endpoint: String) -> String {
        "\(baseURL)\(version)\(endpoint)"
    }
}
