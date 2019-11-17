//
//  StoryboardLoneViewController.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

protocol StoryboardLoneViewController {}

extension StoryboardLoneViewController where Self : UIViewController {
    static var uniqueId: String {
        return String(describing: self)
    }
    
    static func create() -> Self? {
        let storyboard = UIStoryboard(name: uniqueId, bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: uniqueId) as? Self
        return initialViewController
    }
}
