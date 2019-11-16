//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeSceneViewModel?
    var locationFinder: LocationFinder?

    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationFinder = LocationFinder(delegate: self)
        setupViewModel()
        
        tableView.register(UINib(nibName: HomeTableCell.id, bundle: nil),
                           forCellReuseIdentifier: HomeTableCell.id)
        tableView.rowHeight = 150
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
        
        cell.labelCityName.text = viewModel?.items[indexPath.row].name
        
        let temp = "\(viewModel?.items[indexPath.row].main.temp ?? 0)"
        cell.labelTemperatureDegree.text = temp
        
        return cell
    }
}

extension HomeViewController: LocationFinderDelegate {
    func locationUpdatedSuccessfully(location: (lat: Double, long: Double)) {
        viewModel?.locationUpdated(with: location)
    }
    
    func locationUpdateFailed() {
        //TODO: - Handle Location Update Error
    }
}
