//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Alamofire

class AlamofireNetworkManager: NetworkManager {
    
    func request<T>(_ target: TargetType, of type: T.Type,
                    completion: @escaping (WeatherNetworkResult<T>) -> Void) where T : Decodable {
        
        let url = URL(string: "\(target.baseURL)\(target.path)")!
        Alamofire.request(url, method: .get, parameters: target.parameters).responseData { response in
            let decoder = JSONDecoder()
            let result: WeatherNetworkResult<T> = decoder.decodeResponse(from: response)
            completion(result)
        }
    }
}
