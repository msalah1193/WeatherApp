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
    var temperature: String
    var cityName: String
    var weatherIconURL: URL?
    
    init(from responeModel: CityWeather) {
        id = responeModel.id
        temperature = "\(Int(responeModel.main.temp))°"
        cityName = responeModel.name
        
        let baseURL = Bundle.main.object(forInfoDictionaryKey: "WeatherAssetsBaseURL") as? String ?? ""
        let iconName = responeModel.weather.first?.icon ?? ""
        let imageStringURL = "\(baseURL)\(iconName)@2x.png"
        weatherIconURL = URL(string: imageStringURL)
    }
}
