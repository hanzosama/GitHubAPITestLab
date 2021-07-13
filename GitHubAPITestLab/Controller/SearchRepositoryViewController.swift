//
//  ViewController.swift
//  GitHubAPITestLab
//
//  Created by HanzoMac on 20/05/21.
//

import UIKit

class SearchRepositoryViewController: UIViewController {
    
    private let GitApiClient = GitAPIClient(sessionManager: GitHubApiManager().sessionManager)
    private var repositories:[Repository] = []
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = refreshControl
        self.tableView.keyboardDismissMode = .onDrag
        refreshControl.addTarget(self, action: #selector(refreshRepositories), for:.valueChanged)
        
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        fetchRepositories()
    }
    
    private func fetchRepositories() {
        loadingIndicator.isHidden = false
        let query = searchBar.text
        GitApiClient.searchRepositoy(query: query ?? "") { repositories in
            self.repositories = repositories
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.loadingIndicator.isHidden = true
        }
    }
    
    @objc private func refreshRepositories(){
        fetchRepositories()
    }
    
}

// MARK: - table delegate

extension SearchRepositoryViewController: UITableViewDelegate {
    
}

extension SearchRepositoryViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        let repo = repositories[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = repo.description
        
        return cell
    }
    
    
}

extension SearchRepositoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(refreshRepositories), object: nil)
        self.perform(#selector(refreshRepositories),with: nil, afterDelay: 0.5)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.fetchRepositories()
    }
}
