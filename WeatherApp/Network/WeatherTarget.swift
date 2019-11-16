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
}

extension WeatherTarget: TargetType {
    var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "WeatherBaseURL") as? String ?? ""
    }
    
    var path: String {
        return "/weather"
    }
    
    var parameters: [String : Any] {
        var parameters: [String : Any] = [
            "APPID": "e0d94628327b8a6305002389fba1c69c",
            "units": "metric"
        ]
        
        switch self {
        case .city(let name):
            parameters["q"] = name
            break
        case .cityBy(let lat, let long):
            parameters["lat"] = lat
            parameters["lon"] = long
        }
        
        return parameters
    }
}
