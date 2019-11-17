//
//  JSONDecoder+Alamofire.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Alamofire

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> WeatherNetworkResult<T> {
        guard response.error == nil else {
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            return .failure(BackendError.parsing)
        }
        
        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
            
        } catch {
            return .failure(error)
        }
    }
}
