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
    
    func start()
    func locationUpdated(location: (lat: Double, long: Double)?)
    func deleteItem(at index: Int) -> Bool
}

class HomeViewModel: HomeSceneViewModel {
    private var networkManager: NetworkManager?
    private var favoritesManager: FavoritesManager?
    
    var itemsIsLoaded: (([CityWeatherViewModel]) -> Void)?
    var networkProblemClosure: ((Error) -> Void)?
    
    var items: [CityWeatherViewModel] = [] {
        didSet {
            itemsIsLoaded?(items)
        }
    }
    
    init(networkManager: NetworkManager = AlamofireNetworkManager(),
         favoritesManager: FavoritesManager = FavoriteCitiesManager()) {
        
        self.networkManager = networkManager
        self.favoritesManager = favoritesManager
    }
    
    func deleteItem(at index: Int) -> Bool {
        guard favoritesManager?.remove(id: items[index].id) == true else {
            return false
        }
        
        items.remove(at: index)
        return true
    }
    
    func start() {
        guard let favoriteCitiesIds = favoritesManager?.favoriteCities,
            favoriteCitiesIds.count > 0 else {
            
            items = []
            return
        }
        
        getSavedCitiesWeather(by: favoriteCitiesIds)
    }
    
    private func getSavedCitiesWeather(by ids: [Int]) {
        let idsCommaSeprated = ids.reduce("") { $0 + "\($1)," }
        let target = WeatherTarget.listOfCities(ids: idsCommaSeprated)
        
        networkManager?.request(target, of: SearchResponseModel.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                self?.addSavedItems(responseModel)
                
            case .failure(let error):
                self?.networkProblemClosure?(error)
            }
        }
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
        guard let id = cityWeather.id else {
            return
        }
        
        do {
            let isCityAdded = try favoritesManager?.add(id: id)
            items = isCityAdded == true ? [CityWeatherViewModel(from: cityWeather)] : []
        } catch {
            networkProblemClosure?(error)
        }
    }
    
    private func addSavedItems(_ responseModel: SearchResponseModel) {
        guard let responseItems = responseModel.list else {
            return
        }
        
        items = responseItems.map { CityWeatherViewModel(from: $0) }
    }
}
