//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, StoryboardLoneViewController, ErrorHandling, Loading {
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var viewModel: HomeSceneViewModel?
    var router: HomeSceneRouter?
    var locationFinder: LocationFinder?

    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchButton = UIBarButtonItem(title: "Search", style: .plain,
                                           target: self, action: #selector(search))
        navigationItem.rightBarButtonItem = searchButton

        locationFinder = LocationFinder(delegate: self)
        setupViewModel()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startLoading()
        viewModel?.start()
    }
    
    //MARK: - Setup Methods
    func setupTableView() {
        tableView.register(UINib(nibName: HomeTableCell.id, bundle: nil),
                           forCellReuseIdentifier: HomeTableCell.id)
        
        tableView.rowHeight = 150
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupViewModel() {
        viewModel?.itemsIsLoaded = { [weak self] items in
            self?.stopLoading()
            guard items.count > 0 else {
                self?.locationFinder?.start()
                return
            }
            
            self?.tableView.reloadData()
        }
        
        viewModel?.networkProblemClosure = { [weak self] error in
            self?.stopLoading()
            self?.showAlert(with: "Network Problem", message: error.localizedDescription)
        }
    }
    
    //MARK: - Actions
    @objc func search() {
        router?.navigateToSearch()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.id, for: indexPath) as? HomeTableCell else {
            fatalError()
        }
        
        cell.item = viewModel?.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router?.navigateToDetails(with: viewModel?.items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        guard viewModel?.deleteItem(at: indexPath.row) == false else {
            tableView.reloadData()
            return
        }
        
        showAlert(message: LocalStorageError.removing.localizedDescription)
    }
}

extension HomeViewController: LocationFinderDelegate {
    func locationUpdatedSuccessfully(location: (lat: Double, long: Double)) {
        startLoading()
        viewModel?.locationUpdated(location: location)
    }
    
    func locationUpdateFailed() {
        showAlert(message: LocationError.retriving.localizedDescription)
    }
    
    func locationPermissionDenied() {
        startLoading()
        viewModel?.locationUpdated(location: nil)
    }
}
