//
//  LocationManager.swift
//  MorningGlory
//
//  Created by 최대성 on 9/14/24.
//

import SwiftUI
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var userLocation: String?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
    
    func getLocation(lat: Double, lon: Double) {
        let findLocation = CLLocation(latitude: lat, longitude: lon)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: { [weak self] (placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let name: String = address.last?.name { self?.userLocation = name }
            }
        })
    }
}

