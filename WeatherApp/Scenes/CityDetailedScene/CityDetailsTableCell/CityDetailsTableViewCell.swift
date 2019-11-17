//
//  CityDetailsTableViewCell.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

class CityDetailsTableViewCell: UITableViewCell, IdentifiedClass {
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTemp: UILabel!

    @IBOutlet weak var imageViewWeatherIcon: UIImageView!
    
    //MARK: - Variables
    var model: DayWeatherDataViewModel? {
        didSet {
            labelDate.text = model?.date
            labelTemp.text = model?.temperature
            
            imageViewWeatherIcon.kf.setImage(with: model?.weatherIconURL)
        }
    }
}
