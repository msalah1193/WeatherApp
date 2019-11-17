//
//  HomeSceneViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol HomeSceneViewModel: SceneViewModel {
    var itemsIsLoaded: (([CityWeatherViewModel]) -> Void)? { get set }
    var items: [CityWeatherViewModel] { get }
    
    func locationUpdated(location: (lat: Double, long: Double)?)
}

class HomeViewModel: HomeSceneViewModel {
    private var networkManager: NetworkManager?
    
    var itemsIsLoaded: (([CityWeatherViewModel]) -> Void)?
    var networkProblemClosure: ((Error) -> Void)?
    
    var items: [CityWeatherViewModel] = [] {
        didSet {
            itemsIsLoaded?(items)
        }
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func start() {
        let cities: [CityWeather]? = LocalStorageContext.manager.retrive(with: .favCities)
        guard let favoriteCities = cities else {
            items = []
            return
        }
        
        items = favoriteCities.map { CityWeatherViewModel(from: $0) }
    }
    
    func locationUpdated(location: (lat: Double, long: Double)?) {
        let target: WeatherTarget
        
        if let location = location {
            let lat = "\(location.lat)"
            let long = "\(location.long)"
            target = .cityBy(lat: lat, long: long)
        } else {
            target = .city(name: "London")
        }
        
        networkManager?.request(target, of: CityWeather.self) { [weak self] result in
            switch result {
            case .success(let cityWeather):
                self?.addCurrentCityWeather(cityWeather)
                
            case .failure(let error):
                self?.networkProblemClosure?(error)
            }
        }
    }
    
    private func addCurrentCityWeather(_ cityWeather: CityWeather) {
        guard LocalStorageContext.manager.save(data: [cityWeather], with: .favCities) else {
            return
        }
        
        items = [CityWeatherViewModel(from: cityWeather)]
    }
}
