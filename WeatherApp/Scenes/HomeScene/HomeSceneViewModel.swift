//
//  HomeSceneViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol HomeSceneViewModel {
    var itemsIsLoaded: (([CityWeather]) -> Void)? { get set }
    var items: [CityWeather] { get }
    
    func start()
    func locationUpdated(with location: (lat: Double, long: Double))
}

class HomeViewModel: HomeSceneViewModel {
    private var networkManager: NetworkManager?
    
    var itemsIsLoaded: (([CityWeather]) -> Void)?
    var items: [CityWeather] = [] {
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
        
        items = favoriteCities
    }
    
    func locationUpdated(with location: (lat: Double, long: Double)) {
        let lat = "\(location.lat)"
        let long = "\(location.long)"
        
        networkManager?.request(WeatherTarget.cityBy(lat: lat, long: long), of: CityWeather.self)
        { [weak self] result in
            
            switch result {
            case .success(let cityWeather):
                self?.addCurrentCityWeather(cityWeather)
                
            case .failure(let error):
                break
            }
        }
    }
    
    private func addCurrentCityWeather(_ cityWeather: CityWeather) {
        guard LocalStorageContext.manager.save(data: [cityWeather], with: .favCities) else {
            return
        }
        
        items = [cityWeather]
    }
}
