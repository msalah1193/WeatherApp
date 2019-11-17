//
//  TemperatureFormatter.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

class TemperatureFormatter {
    static let tempDegreeSymbol = "°"
    static let defaultTemp = "--"
    
    static func formattedTemp(with degree: Double?) -> String {
        guard let degree = degree else {
            return defaultTemp
        }
        
         let integerDegree = Int(degree)
        return "\(integerDegree)\(tempDegreeSymbol)"
    }
}
