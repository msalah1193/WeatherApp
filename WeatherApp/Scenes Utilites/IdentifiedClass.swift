//
//  IdentifiedClass.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import Foundation

protocol IdentifiedClass {}

extension IdentifiedClass {
    static var id: String {
        return String(describing: self)
    }
}
