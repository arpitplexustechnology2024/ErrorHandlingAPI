//
//  CommentsViewModel.swift
//  ErrorHandlingAPI
//
//  Created by Arpit iOS Dev. on 15/06/24.
//

import Foundation
import UIKit

class CommentsViewModel {
    
    private var networkManager: NetworkManager
    var quotes: [WelcomeElement] = []
    var stateChangeHandler: ((APIState<[WelcomeElement]>) -> Void)?
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    func fetchRandomQuotes(count: Int) {
        stateChangeHandler?(.loading(true))
        
        networkManager.fetchRandomQuote(count: count) { [weak self] result in
            switch result {
            case .success(let quotes):
                self?.quotes = quotes
                self?.stateChangeHandler?(.success(quotes))
            case .failure(let error):
                self?.stateChangeHandler?(.failure(error))
            }
        }
    }
}
