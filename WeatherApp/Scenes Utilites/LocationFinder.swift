//
//  LocationFinder.swift
//  WeatherApp
//
//  Created by Mohamed Salah Younis on 11/16/19.
//  Copyright © 2019 Mohamed Salah Younis. All rights reserved.
//

import CoreLocation

protocol LocationFinderDelegate: class {
    func locationUpdatedSuccessfully(location: (lat: Double, long: Double))
    func locationUpdateFailed()
    func locationPermissionDenied()
}

class LocationFinder: NSObject {
    private weak var delegate: LocationFinderDelegate?
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        
        return locationManager
    }()
    
    init(delegate: LocationFinderDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.startUpdatingLocation()
    }
}

extension LocationFinder: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            delegate?.locationPermissionDenied()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            return
        }
        
        locationManager.stopUpdatingLocation()
        
        let lat = Double(currentLocation.coordinate.latitude)
        let long = Double(currentLocation.coordinate.longitude)
        delegate?.locationUpdatedSuccessfully(location: (lat, long))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
