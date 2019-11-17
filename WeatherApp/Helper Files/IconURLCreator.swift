//
//  IconURLCreator.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

struct IconURLCreator {
    static func create(with iconName: String?) -> URL? {
        guard let iconName = iconName else {
            return nil
        }
        
        let baseURL = Bundle.main.object(forInfoDictionaryKey: "WeatherAssetsBaseURL") as? String ?? ""
        let imageStringURL = "\(baseURL)\(iconName)@2x.png"
        return URL(string: imageStringURL)
    }
}
