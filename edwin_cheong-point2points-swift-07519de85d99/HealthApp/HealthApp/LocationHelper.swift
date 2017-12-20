//
//  LocationHelper.swift
//  HealthApp
//
//  Created by Edwin Cheong on 23/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import CoreLocation

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    private func isGPSAvailable() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
            return true
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    public func getLatLong() -> Location {
        let locationModel = Location()
        
        if isGPSAvailable() != false {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
            let location = self.locationManager.location
            locationModel.latitude = location?.coordinate.latitude
            locationModel.longtitude = location?.coordinate.longitude
         
           
        }
        
        return locationModel
    }
    
    public func displayLocationInfo(placeMark:CLPlacemark?) -> Country {
        let country = Country()
        
        if isGPSAvailable() != false {
            if let containsPlacemark = placeMark {
                //stop updating location to save battery life
                locationManager.stopUpdatingLocation()

                let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
                let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
                let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
                let countrySelect = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
                
                country.country = countrySelect
                country.locality = locality
                country.postalCode = postalCode
                country.administrativeArea = administrativeArea
            }
        }
        
        return country
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isGPSAvailable() != false {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
}
