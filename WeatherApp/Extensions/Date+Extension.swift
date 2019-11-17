//
//  Date+Extension.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case detailsDisplay = "EEEE, dd/MM/yyyy, hh a"
}

//MARK: - Date Extension
extension Date {
    static func formatedDate(from timeInterval: Int, with format: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
  
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = format.rawValue
        
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
}
