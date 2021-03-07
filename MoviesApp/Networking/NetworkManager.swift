//
//  NetworkManager.swift
//  MoviesApp
//
//  Created by Олег Еременко on 03.03.2021.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidResponse
    case nilResponse
}

final class NetworkManager<T: Codable> {
    static func fetch(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        AF.request(urlString)
            .responseDecodable(of: T.self) { response in
                if let error = response.error {
                    completion(.failure(.invalidResponse))
                    print(error.localizedDescription)
                    return
                }
                if let payload = response.value {
                    completion(.success(payload))
                    return
                }
                completion(.failure(.nilResponse))
            }
    }
}
