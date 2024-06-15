//
//  NetworkManager.swift
//  ErrorHandlingAPI
//
//  Created by Arpit iOS Dev. on 15/06/24.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://andruxnet-random-famous-quotes.p.rapidapi.com/"
    private let apiKey = "e103305047msh67c54e4389f5e37p106668jsn6f55a35f4271"
    private init() {}
    
    func fetchRandomQuote(count: Int, completion: @escaping (Result<[WelcomeElement], APIError>) -> Void) {
        let headers: HTTPHeaders = [
            "X-RapidAPI-Key": apiKey
        ]
        
        let parameters: [String: Any] = [
            "cat": "movies",
            "count": count
        ]
        
        AF.request(baseURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [[String: Any]] {
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                            let quotes = try JSONDecoder().decode([WelcomeElement].self, from: jsonData)
                            completion(.success(quotes))
                        } catch {
                            completion(.failure(.jsonParsingFailure))
                        }
                    } else {
                        completion(.failure(.jsonParsingFailure))
                    }
                case .failure:
                    if let httpResponse = response.response, !(200..<300).contains(httpResponse.statusCode) {
                        completion(.failure(.responseUnsuccessful))
                    } else {
                        completion(.failure(.requestFailed))
                    }
                }
            }
    }
}
