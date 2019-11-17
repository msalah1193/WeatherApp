//
//  SearchSceneRouter.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

protocol SearchSceneRouter {
    var viewController: SearchTableViewController? { get set}
    func navigateToDetails(with model: CityWeatherViewModel?)
}

class SearchViewControllerRouter: SearchSceneRouter {
    weak var viewController: SearchTableViewController?
    
    func navigateToDetails(with model: CityWeatherViewModel?) {
        guard let model = model,
            let detailsVC = CityDetailsViewController.create() else {
                return
        }
        
        detailsVC.viewModel = CityDetailsViewModel(city: model)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
