//
//  AppErrors.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

enum BackendError: LocalizedError {
    case parsing
    
    var errorDescription: String? {
        return "Did not get data in response"
    }
}

enum LocationError: LocalizedError {
    case retriving
    
    var errorDescription: String? {
        return "We Can't Update Your Location"
    }
}

enum LocalStorageError: LocalizedError {
    case removing
    case adding
    case updating
    
    var errorDescription: String? {
        switch self {
        case .removing:
            return "error while removing data"
        case .adding:
            return "error while adding data"
        case .updating:
            return "Failed to update data. try again!!"
        }
    }
}

enum FavoriteCitiesError: LocalizedError {
    case limitExceeded
    
    var errorDescription: String? {
        return "You reached the maximum number of favorites cities"
    }
}
