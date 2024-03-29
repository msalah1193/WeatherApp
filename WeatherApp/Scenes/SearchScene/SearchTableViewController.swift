//
//  SearchTableViewController.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, ErrorHandling, Loading {
    //MARK: - Variables
    let cellId = "SearchTableCell"
    var viewModel: SearchSceneViewModel?
    var router: SearchSceneRouter?
    
    lazy var searchBar: UISearchBar = {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        return UISearchBar(frame: frame)
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupSearchBar()
        setupTableView()
    }
    
    //MARK: - Setup
    func setupViewModel() {
        viewModel?.itemsIsLoaded = { [weak self] in
            self?.stopLoading()
            self?.searchBar.isUserInteractionEnabled = true
            self?.tableView.reloadData()
        }
        
        viewModel?.networkProblemClosure = { [weak self] error in
            self?.stopLoading()
            self?.searchBar.isUserInteractionEnabled = true
            self?.showAlert(message: error.localizedDescription)
        }
    }
    
    func setupSearchBar() {
        searchBar.placeholder = "Type Full City Name"
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Table view data source
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = viewModel?.items[indexPath.row].displayName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel?.getDetailsModel(for: indexPath.row)
        router?.navigateToDetails(with: model)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        searchBar.endEditing(true)
        searchBar.isUserInteractionEnabled = false
        
        startLoading()
        viewModel?.search(with: searchText)
    }
}
