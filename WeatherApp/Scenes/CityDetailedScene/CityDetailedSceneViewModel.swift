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
    
    func start()
    func isAddedToFavorites() -> Bool
    func favoriteActionClicked()
}

class CityDetailsViewModel: CityDetailedSceneViewModel {
    private var networkManager: NetworkManager?
    private var cityWeather: CityWeatherViewModel
    
    var itemsIsLoaded: ((DetailsViewModel?) -> Void)?
    var networkProblemClosure: ((Error) -> Void)?
    
    var model: DetailsViewModel? {
        didSet {
            itemsIsLoaded?(model)
        }
    }
    
    init(city: CityWeatherViewModel, networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.cityWeather = city
    }
    
    func start() {
        networkManager?.request(WeatherTarget.cityDetails(id: cityWeather.id),
                                of: CityDetailedWeather.self) { [weak self] result in
            
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
    
    func isAddedToFavorites() -> Bool {
        guard let cities: [CityWeather] = LocalStorageContext.manager.retrive(with: .favCities) else {
            return false
        }
        
        let filteredCities = cities.filter { $0.id == self.cityWeather.id }
        return filteredCities.count == 1
    }
    
    func favoriteActionClicked() {
        
    }
}
