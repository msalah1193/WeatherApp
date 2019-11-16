//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, ErrorHandling {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var searchBar: UISearchBar = {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 20)
        return UISearchBar(frame: frame)
    }()
    
    var viewModel: HomeSceneViewModel?
    var locationFinder: LocationFinder?
    

    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "Your placeholder"
        navigationItem.titleView = searchBar
        
        locationFinder = LocationFinder(delegate: self)
        setupViewModel()
        
        tableView.register(UINib(nibName: HomeTableCell.id, bundle: nil),
                           forCellReuseIdentifier: HomeTableCell.id)
        tableView.rowHeight = 150
        tableView.dataSource = self
    }
    
    //MARK: - Setup Methods
    func setupViewModel() {
        viewModel?.itemsIsLoaded = { [weak self] items in
            guard items.count > 0 else {
                self?.locationFinder?.start()
                return
            }
            
            self?.tableView.reloadData()
        }
        
        viewModel?.networkProblemClosure = { [weak self] error in
            self?.showAlert(with: "Network Problem", message: error.localizedDescription)
        }
        
        viewModel?.start()
    }
}

extension HomeViewController: UITableViewDataSource {
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
}

extension HomeViewController: LocationFinderDelegate {
    func locationUpdatedSuccessfully(location: (lat: Double, long: Double)) {
        viewModel?.locationUpdated(location: location)
    }
    
    func locationUpdateFailed() {
        showAlert(with: "Location Problem", message: "We Can Update Your Location")
    }
    
    func locationPermissionDenied() {
        viewModel?.locationUpdated(location: nil)
    }
}
