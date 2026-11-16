//
//  FireBaseManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 14.11.26.
//

import Foundation
import FirebaseCrashlytics

final class FireBaseManager {
    static let shared = FireBaseManager()
    
    private init () {}
    
    func recordError(message: String, endpoint: String) {
        let error = NSError(domain: "com.sasacademy.CookApp",
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: message,
                                       "endpoint": endpoint])
        Crashlytics.crashlytics().record(error: error)
    }
}
