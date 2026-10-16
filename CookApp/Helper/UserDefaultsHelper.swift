//
//  UserDefaultsHelper.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import Foundation

class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    
    private init () {}
    
    private let userDefaults = UserDefaults.standard
    
    var hasSeenOnboarding: Bool {
        get { userDefaults.bool(forKey: "hasSeenOnboarding") }
        set { userDefaults.set(newValue, forKey: "hasSeenOnboarding") }
    }
    
    var favoriteCuisinesID: [Int] {
        get { userDefaults.array(forKey: "favoriteCuisinesID") as? [Int] ?? [] }
        set { userDefaults.set(newValue, forKey: "favoriteCuisinesID") }
    }
}
