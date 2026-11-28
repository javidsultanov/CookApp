//
//  CoreManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 12.10.26.
//

import Foundation
import Alamofire

class CoreManager {    
    func request<T: Codable> (model: T.Type,
                              endpoint: String,
                              method: HTTPMethod = .get,
                              parameter: Parameters? = nil,
                              encoding: EncodingType = .url) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            AF.request(endpoint,
                       method: method,
                       parameters: parameter,
                       encoding: encoding == .url ? URLEncoding.default : JSONEncoding.default,
                       headers: CoreHelper.shared.headers).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
