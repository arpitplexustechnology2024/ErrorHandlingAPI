//
//  ViewController.swift
//  ErrorHandlingAPI
//
//  Created by Arpit iOS Dev. on 15/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel: CommentsViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        viewModel = CommentsViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        activityIndicator.style = .large
        bindViewModel()
        fetchRandomQuotes(count: 10)
    }
    
    private func bindViewModel() {
        viewModel.stateChangeHandler = { [weak self] state in
            switch state {
            case .loading(let isLoading):
                DispatchQueue.main.async {
                    if isLoading {
                        self?.activityIndicator.startAnimating()
                    } else {
                        self?.activityIndicator.stopAnimating()
                    }
                }
            case .success:
                DispatchQueue.main.async {
                    self?.tableView.isHidden = false
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.showAlert(message: self?.errorMessage(from: error))
                }
            }
        }
    }
    
    func fetchRandomQuotes(count: Int) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.viewModel.fetchRandomQuotes(count: count)
        }
        }
    
    func showAlert(message: String?) {
        guard let message = message else { return }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func errorMessage(from error: APIError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL."
        case .requestFailed:
            return "Request failed."
        case .responseUnsuccessful:
            return "Response unsuccessful."
        case .invalidData:
            return "Invalid data received."
        case .jsonParsingFailure:
            return "JSON parsing failed."
        case .custom(let message):
            return message
        }
    }
}
// MARK: - TableView Dalegate & Datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let quotes = viewModel.quotes[indexPath.row]
        cell.quoteLbl.text = quotes.quote
        cell.authorLbl.text = quotes.author
        cell.categoryLbl.text = quotes.category
        return cell
    }
}
