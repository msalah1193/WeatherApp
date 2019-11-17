//
//  CityDetailsViewController.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

enum FavoriteButtonStatus: String {
    case isIncluded = "Remove From Favorites"
    case notIncluded = "Add To Favorites"
}

class CityDetailsViewController: UIViewController, StoryboardLoneViewController, ErrorHandling, Loading {
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelCurrentTemp: UILabel!
    
    @IBOutlet weak var imageViewWeatherIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var viewModel: CityDetailedSceneViewModel?
    
    var favBtnTitle: String {
        let favButtonTitle: FavoriteButtonStatus
        favButtonTitle = viewModel?.isFavoriteCity == true ? .isIncluded : .notIncluded
        return favButtonTitle.rawValue
    }
    
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
        guard viewModel?.isHomeCity == false else {
            return
        }
        
        let favButton = UIBarButtonItem(title: favBtnTitle, style: .plain,
                                        target: self, action: #selector(favButtonClicked))
        navigationItem.rightBarButtonItem = favButton
    }
    
    func setupViewModel() {
        viewModel?.itemsIsLoaded = { [weak self] detailsModel in
            self?.stopLoading()
            self?.setupSceneContent(with: detailsModel)
            self?.tableView.reloadData()
        }
        
        viewModel?.networkProblemClosure = { [weak self] error in
            self?.stopLoading()
            self?.showAlert(message: error.localizedDescription)
        }
        
        startLoading(color: .white)
        viewModel?.start()
    }
    
    func setupSceneContent(with model: DetailsViewModel?) {
        labelCityName.text = model?.cityName
        labelCurrentTemp.text = model?.temperature
        
        imageViewWeatherIcon.kf.setImage(with: model?.weatherIconURL)
    }
    
    //MARK: - Actions
    @objc func favButtonClicked() {
        guard viewModel?.updateFavoriteList() == true else {
            showAlert(message: LocalStorageError.updating.localizedDescription)
            return
        }
        
        navigationItem.rightBarButtonItem?.title = favBtnTitle
    }
}

extension CityDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model?.daysData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityDetailsTableViewCell.id, for: indexPath) as? CityDetailsTableViewCell else {
            fatalError()
        }
        
        cell.model = viewModel?.model?.daysData[indexPath.row]
        return cell
    }
}
