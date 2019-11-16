//
//  HomeTableCell.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

class HomeTableCell: UITableViewCell {
    @IBOutlet weak var labelTemperatureDegree: UILabel!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var imageViewWeatherIcon: UIImageView!
    
    static let id = "HomeTableCell"
    
    var item: CityWeatherViewModel? {
        didSet {
            labelTemperatureDegree.text = item?.temperature
            labelCityName.text = item?.cityName
        }
    }
    
    //MARK: - setup
    
}
