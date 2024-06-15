//
//  ErrorHandling.swift
//  ErrorHandlingAPI
//
//  Created by Arpit iOS Dev. on 15/06/24.
//

import Foundation
import UIKit

enum APIState<T> {
    case loading(Bool)
    case success(T)
    case failure(APIError)
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonParsingFailure
    case custom(message: String)
}
