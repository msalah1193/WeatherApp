//
//  DetailsViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

struct DetailsViewModel {
    var temperature: String
    var cityName: String
    var weatherIconURL: URL?
    var daysData: [DayWeatherDataViewModel]
    
    init(from model: CityDetailedWeather, cityWeather: CityWeatherViewModel) {
        temperature = cityWeather.temperature
        cityName = model.city?.name ?? "Unknown"
        weatherIconURL = cityWeather.weatherIconURL
        
        daysData = model.list.map { DayWeatherDataViewModel(from: $0) }
    }
}

//MARK: - DayWeatherDataViewModel
struct DayWeatherDataViewModel {
    var date: String = ""
    var temperature: String = ""
    var weatherIconURL: URL?
    
    init(from listItem: WeatherDetailedList) {
        if let timeInterval = listItem.dt {
            date = Date.formatedDate(from: timeInterval, with: .detailsDisplay)
        }
        
        if let tempDouble = listItem.main?.temp {
            temperature = "\(Int(tempDouble))°"
        }
        
        let baseURL = Bundle.main.object(forInfoDictionaryKey: "WeatherAssetsBaseURL") as? String ?? ""
        let iconName = listItem.weather?.first?.icon ?? ""
        let imageStringURL = "\(baseURL)\(iconName)@2x.png"
        weatherIconURL = URL(string: imageStringURL)
    }
}
