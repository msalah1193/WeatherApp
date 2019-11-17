//
//  WeatherTarget.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

enum WeatherTarget {
    case city(name: String)
    case cityBy(lat: String, long: String)
    case listOfCities(ids: String)
    
    case cityDetails(id: Int)
    case search(name: String)
}

extension WeatherTarget: TargetType {
    var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherBaseURL") as? String ?? ""
    }
    
    var appId: String {
        return Bundle.main.object(forInfoDictionaryKey: "APPID") as? String ?? ""
    }
    
    var path: String {
        switch self {
        case .city, .cityBy:
            return "/weather"
        case .listOfCities:
            return "/group"
        case .cityDetails:
            return "/forecast"
        case .search:
            return "/find"
        }
    }
    
    var parameters: [String : Any] {
        var parameters: [String : Any] = [
            "APPID": appId,
            "units": "metric"
        ]
        
        switch self {
        case .city(let name), .search(let name):
            parameters["q"] = name
        
        case .listOfCities(let ids):
            parameters["id"] = ids
            
        case .cityBy(let lat, let long):
            parameters["lat"] = lat
            parameters["lon"] = long
            
        case .cityDetails(let id):
            parameters["id"] = id
        }
        
        return parameters
    }
}
