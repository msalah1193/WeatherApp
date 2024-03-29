//
//  FavoriteCitiesManager.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol FavoritesManager {
    var favoriteCities: [Int]? { get }
    
    func isFavorite(id: Int) -> Bool
    func isHomeCity(with id: Int) -> Bool
    
    func add(id: Int) throws -> Bool
    func remove(id: Int) -> Bool
}

class FavoriteCitiesManager: FavoritesManager {
    private let localSotage = LocalStorageContext.manager
    
    var favoriteCities: [Int]? {
        return localSotage.retrive(with: .favCities)
    }
    
    func isFavorite(id: Int) -> Bool {
        return favoriteCities?.filter { $0 == id }.count == 1
    }
    
    func isHomeCity(with id: Int) -> Bool {
        return favoriteCities?.first == id
    }
    
    func add(id: Int) throws -> Bool {
        guard var updatedCitiesIds = favoriteCities else {
            return localSotage.save(data: [id], with: .favCities)
        }
        
        guard updatedCitiesIds.count < 5 else {
            throw FavoriteCitiesError.limitExceeded
        }
        
        updatedCitiesIds.append(id)
        return localSotage.save(data: updatedCitiesIds, with: .favCities)
    }
    
    func remove(id: Int) -> Bool {
        guard let cities = favoriteCities else {
            return false
        }
        
        let newFavoriteCities = cities.filter { $0 != id }
        return localSotage.save(data: newFavoriteCities, with: .favCities)
    }
}
