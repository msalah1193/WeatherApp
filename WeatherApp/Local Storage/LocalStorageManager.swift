//
//  LocalStorageManager.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

class LocalStorageContext {
    static let manager: LocalStorageManager = UserDefaultsStorageManager()
}

protocol LocalStorageManager {
    func save<T: Encodable>(data: T, with key: LocalStorageKey) -> Bool
    func retrive<T: Decodable>(with key: LocalStorageKey) -> T?
}

enum LocalStorageKey: String {
    case favCities
}

struct UserDefaultsStorageManager: LocalStorageManager {
    private let defaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func save<T>(data: T, with key: LocalStorageKey) -> Bool where T : Encodable {
        guard let encoded = try? encoder.encode(data) else {
            return false
        }
        
        defaults.set(encoded, forKey: key.rawValue)
        return true
    }
    
    func retrive<T>(with key: LocalStorageKey) -> T? where T : Decodable {
        guard let savedObject = defaults.object(forKey: key.rawValue) as? Data else {
            return nil
        }
        
        guard let savedEncodedObject = try? decoder.decode(T.self, from: savedObject) else {
            return nil
        }
        
        return savedEncodedObject
    }
}
