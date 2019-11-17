//
//  HomeSceneRouter.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol HomeSceneRouter {
    var viewController: HomeViewController? { get set}
    
    func navigateToDetails(with model: CityWeatherViewModel?)
    func navigateToSearch()
}

class HomeViewControllerRouter: HomeSceneRouter {
    weak var viewController: HomeViewController?
    
    func navigateToDetails(with model: CityWeatherViewModel?) {
        guard let model = model,
            let detailsVC = CityDetailsViewController.create() else {
            return
        }
        
        detailsVC.viewModel = CityDetailsViewModel(city: model)
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func navigateToSearch() {
        let searchVC = SearchTableViewController()
        searchVC.viewModel = SearchViewModel()
        searchVC.router = SearchViewControllerRouter()
        searchVC.router?.viewController = searchVC
        
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
