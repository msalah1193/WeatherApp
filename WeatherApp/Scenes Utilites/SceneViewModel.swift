//
//  SceneViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol SceneViewModel {
    var networkProblemClosure: ((Error) -> Void)? { get set }
    func start()
}
