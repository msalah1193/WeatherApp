//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

struct CityWeatherViewModel {
    var id: Int
    var temperature: String = ""
    var cityName: String
    var weatherIconURL: URL?
    
    init(from responeModel: CityWeather) {
        id = responeModel.id ?? -1
        cityName = responeModel.name ?? "Unknown"
        
        let iconName = responeModel.weather?.first?.icon ?? ""
        setIcon(with: iconName)
        
        if let tempDouble = responeModel.main?.temp {
            temperature = "\(Int(tempDouble))°"
        }
    }
    
    init(from weatherListItem: WeatherDetailedList) {
        id = weatherListItem.id ?? -1
        cityName = weatherListItem.name ?? "Unknown"
        
        let iconName = weatherListItem.weather?.first?.icon ?? ""
        setIcon(with: iconName)
        
        if let tempDouble = weatherListItem.main?.temp {
            temperature = "\(Int(tempDouble))°"
        }
    }
    
    private mutating func setIcon(with iconName: String) {
        let baseURL = Bundle.main.object(forInfoDictionaryKey: "WeatherAssetsBaseURL") as? String ?? ""
        let imageStringURL = "\(baseURL)\(iconName)@2x.png"
        weatherIconURL = URL(string: imageStringURL)
    }
}
