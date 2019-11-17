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
    
    var viewModel: HomeSceneViewModel?
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
    
    @objc func search() {
        let searchViewController = SearchTableViewController()
        searchViewController.viewModel = SearchViewModel(networkManager: AlamofireNetworkManager())
        navigationController?.pushViewController(searchViewController, animated: true)
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
        let storyboard = UIStoryboard(name: "CityDetailsViewController", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "CityDetailsViewController") as! CityDetailsViewController
        initialViewController.viewModel = CityDetailsViewModel(city: viewModel!.items[indexPath.row], networkManager: AlamofireNetworkManager())
        navigationController?.pushViewController(initialViewController, animated: true)
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
