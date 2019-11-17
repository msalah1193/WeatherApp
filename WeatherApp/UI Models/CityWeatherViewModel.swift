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
        cityName = responeModel.name ?? ""
        
        let iconName = responeModel.weather?.first?.icon
        weatherIconURL = IconURLCreator.create(with: iconName)
        
        let tempDouble = responeModel.main?.temp
        temperature = TemperatureFormatter.formattedTemp(with: tempDouble)
    }
    
    init(from weatherListItem: WeatherDetailedList) {
        id = weatherListItem.id ?? -1
        cityName = weatherListItem.name ?? ""
        
        let iconName = weatherListItem.weather?.first?.icon
        weatherIconURL = IconURLCreator.create(with: iconName)
        
        let tempDouble = weatherListItem.main?.temp
        temperature = TemperatureFormatter.formattedTemp(with: tempDouble)
    }
}
