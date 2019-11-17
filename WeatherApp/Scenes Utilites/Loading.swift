//
//  Loading.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/17/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import UIKit

protocol Loading {}

extension Loading where Self : UIViewController {
    func startLoading(color: UIColor = .black) {
        guard view.subviews.filter({ $0 is UIActivityIndicatorView }).count == 0 else {
            return
        }
        
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.color = color
        activityView.center = view.center
        
        view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func stopLoading() {
        for view in view.subviews where view is UIActivityIndicatorView {
            view.removeFromSuperview()
        }
    }
}
