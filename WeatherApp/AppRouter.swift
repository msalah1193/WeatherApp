//
//  AppRouter.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

class AppRouter {
    static func root() -> UIViewController? {
        guard let homeVC = HomeViewController.create() else {
            return nil
        }
        
        homeVC.viewModel = HomeViewModel()
        homeVC.router = HomeViewControllerRouter()
        homeVC.router?.viewController = homeVC
        
        return UINavigationController(rootViewController: homeVC)
    }
}
