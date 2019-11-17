//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

struct SearchTableCellViewModel {
    var displayName: String
    var id: Int
    
    init(from searchListModel: WeatherDetailedList) {
        id = searchListModel.id ?? -1
        
        guard let name = searchListModel.name,
            let countryName = searchListModel.sys?.country else {
            displayName = ""
            return
        }
        
        displayName = "\(name), \(countryName)"
    }
    
}
