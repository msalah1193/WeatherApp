//
//  CityDetailedSceneViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol CityDetailedSceneViewModel: SceneViewModel {
    var itemsIsLoaded: ((DetailsViewModel?) -> Void)? { get set }
    var model: DetailsViewModel? { get set }
    var isFavoriteCity: Bool { get }
    var isHomeCity: Bool { get }
    
    func start()
    func updateFavoriteList() -> Bool
}

class CityDetailsViewModel: CityDetailedSceneViewModel {
    private var networkManager: NetworkManager?
    private var favoritesManager: FavoritesManager?
    private var cityWeather: CityWeatherViewModel
    
    var itemsIsLoaded: ((DetailsViewModel?) -> Void)?
    var networkProblemClosure: ((Error) -> Void)?
    
    var model: DetailsViewModel? {
        didSet {
            itemsIsLoaded?(model)
        }
    }
    
    var isFavoriteCity: Bool {
        return favoritesManager?.isFavorite(id: cityWeather.id) ?? false
    }
    
    var isHomeCity: Bool {
        return favoritesManager?.isHomeCity(with: cityWeather.id) ?? false
    }
    
    init(city: CityWeatherViewModel,
         networkManager: NetworkManager = AlamofireNetworkManager(),
         favoritesManager: FavoritesManager = FavoriteCitiesManager()) {
        
        self.networkManager = networkManager
        self.favoritesManager = FavoriteCitiesManager()
        self.cityWeather = city
    }
    
    func start() {
        let target = WeatherTarget.cityDetails(id: cityWeather.id)
        networkManager?.request(target, of: CityDetailedWeather.self) { [weak self] result in
            switch result {
            case .success(let weatherDetails):
                self?.setModel(with: weatherDetails)
            case .failure:
                break
            }
        }
    }
    
    private func setModel(with responseModel: CityDetailedWeather) {
        model = DetailsViewModel(from: responseModel, cityWeather: cityWeather)
    }
    
    func updateFavoriteList() -> Bool {
        guard let favoritesManager = favoritesManager else {
            return false
        }
        
        guard isFavoriteCity else {
            return favoritesManager.add(id: cityWeather.id)
        }
        
        return favoritesManager.remove(id: cityWeather.id)
    }
}
