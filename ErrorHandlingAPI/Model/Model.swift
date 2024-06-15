//
//  Model.swift
//  ErrorHandlingAPI
//
//  Created by Arpit iOS Dev. on 15/06/24.
//

import Foundation

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let quote, author: String
    let category: String
}
