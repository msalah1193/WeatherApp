//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol NetworkManager {
    func request<T: Decodable>(_ target: TargetType, of type: T.Type,
                               completion: @escaping (WeatherNetworkResult<T>) -> Void)
}

protocol TargetType {
    var baseURL: String { get }
    
    var path: String { get }
    
    var parameters: [String: Any] { get }
}

enum WeatherNetworkResult<T> {
    case success(T)
    case failure(Error)
}

