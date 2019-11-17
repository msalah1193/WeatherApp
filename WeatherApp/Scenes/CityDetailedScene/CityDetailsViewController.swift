//
//  CityDetailsViewController.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

class CityDetailsViewController: UIViewController {
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelCurrentTemp: UILabel!
    
    @IBOutlet weak var imageViewWeatherIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var viewModel: CityDetailedSceneViewModel?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTableView()
        setupNavigationBar()
    }
    
    //MARK: - Setup
    func setupTableView() {
        tableView.register(UINib(nibName: CityDetailsTableViewCell.id, bundle: nil),
                           forCellReuseIdentifier: CityDetailsTableViewCell.id)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        tableView.dataSource = self
    }
    
    func setupNavigationBar() {
        
        let favButtonTitle: String
        if viewModel?.isAddedToFavorites() == true {
            favButtonTitle = "Remove From Favorites"
        } else {
            favButtonTitle = "Add To Favorites"
        }
        
        let favButton = UIBarButtonItem(title: favButtonTitle, style: .plain,
                                        target: self, action: #selector(favButtonClicked))
        navigationItem.rightBarButtonItem = favButton
    }
    
    func setupViewModel() {
        viewModel?.itemsIsLoaded = { [weak self] detailsModel in
            self?.setupSceneContent(with: detailsModel)
            self?.tableView.reloadData()
        }
        
        viewModel?.start()
    }
    
    func setupSceneContent(with model: DetailsViewModel?) {
        labelCityName.text = model?.cityName
        labelCurrentTemp.text = model?.temperature
        
        imageViewWeatherIcon.kf.setImage(with: model?.weatherIconURL)
    }
    
    //MARK: - Actions
    @objc func favButtonClicked() {
        guard viewModel?.updateFavoriteList() == false else {
            return
        }
        
    }
}

extension CityDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.daysData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: CityDetailsTableViewCell.id,
                                 for: indexPath) as? CityDetailsTableViewCell else {
                fatalError()
        }
        
        cell.model = viewModel?.model?.daysData[indexPath.row]
        return cell
    }
}
