//
//  CoreManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 12.10.26.
//

import Foundation
import Alamofire

class CoreManager {
    func request<T: Codable>(model: T.Type,
                             endpoint: String,
                             method: HTTPMethod = .get,
                             parameter: Parameters? = nil,
                             encoding: EncodingType = .url,
                             completion: @escaping (T?, String?) -> Void) {
        AF.request(CoreHelper.shared.configureURL(endpoint: endpoint),
                   method: method,
                   parameters: parameter,
                   encoding: encoding == .url ? URLEncoding.default : JSONEncoding.default,
                   headers: CoreHelper.shared.headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(decodedData, nil)
                } catch {
                    completion(nil, error.localizedDescription)
                }
            case .failure(let error):
                let errorMessage = error.localizedDescription
                completion(nil, errorMessage)
            }
        }
    }
}
