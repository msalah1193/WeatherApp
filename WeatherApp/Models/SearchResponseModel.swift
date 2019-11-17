//
//  SearchResponseModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

// MARK: - SearchResponseModel
struct SearchResponseModel: Codable {
    let message, cod: String?
    let count: Int?
    let list: [WeatherDetailedList]?
}
