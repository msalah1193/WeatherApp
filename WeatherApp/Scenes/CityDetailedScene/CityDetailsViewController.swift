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
        
        tableView.register(UINib(nibName: CityDetailsTableViewCell.id, bundle: nil),
                           forCellReuseIdentifier: CityDetailsTableViewCell.id)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        tableView.dataSource = self
    }
    
    //MARK: - Setup
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
