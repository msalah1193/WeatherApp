//
//  CityDetailedWeather.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

// MARK: - CityDetailedWeather
struct CityDetailedWeather: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [WeatherDetailedList]
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let timezone, sunrise, sunset: Int?
}

// MARK: - List
struct WeatherDetailedList: Codable {
    let id: Int?
    let dt: Int?
    let name: String?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let sys: Sys?
    let dtTxt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Sys
struct Sys: Codable {
    let pod, country: String?
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}
