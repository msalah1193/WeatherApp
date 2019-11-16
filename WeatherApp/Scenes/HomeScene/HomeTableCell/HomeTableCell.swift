//
//  HomeTableCell.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit
import Kingfisher

class HomeTableCell: UITableViewCell {
    @IBOutlet weak var labelTemperatureDegree: UILabel!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var imageViewWeatherIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Variables
    static let id = "HomeTableCell"
    
    var item: CityWeatherViewModel? {
        didSet {
            labelTemperatureDegree.text = item?.temperature
            labelCityName.text = item?.cityName
            imageViewWeatherIcon.kf.setImage(with: item?.weatherIconURL)
        }
    }
    
    //MARK: - setup
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
    }
}
