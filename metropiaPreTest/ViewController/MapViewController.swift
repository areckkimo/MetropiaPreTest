//
//  MapViewController.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Property
    
    var lastLocation: CLLocation?
    let geoCoder = CLGeocoder()
    
    lazy var locationManager: CLLocationManager = {
        let _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .fitness
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //Core Location
        locationManager.requestWhenInUseAuthorization()
    }

}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else{
            return
        }
        guard let lastLocation = self.lastLocation else{
            self.lastLocation = newLocation
            saveNewLocation(newLocation)
            return
        }
        if newLocation.timestamp - lastLocation.timestamp > 60 {
            self.lastLocation = newLocation
            saveNewLocation(newLocation)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let locationAuthStatus = manager.authorizationStatus
        if locationAuthStatus == .authorizedAlways || locationAuthStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }else if locationAuthStatus == .denied || locationAuthStatus == .restricted {
            let alert = UIAlertController(title: "APP需要定位權限，軌跡記錄功能才可使用", message: nil, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "確認", style: .default, handler: nil)
            let settingAction = UIAlertAction(title: "去設置", style: .destructive) { (_) in
                
                let settingURLString = UIApplication.openSettingsURLString
                guard let bundleId = Bundle.main.bundleIdentifier,
                      let url = URL(string: "\(settingURLString)&path=LOCATION/\(bundleId)"),
                      UIApplication.shared.canOpenURL(url) else {
                    return
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
            alert.addAction(confirmAction)
            alert.addAction(settingAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func saveNewLocation(_ newLocation: CLLocation) {
        
        geoCoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            guard error == nil, let placemark = placemarks?.first else{
                return
            }
            
            let placemarkAttributes = [placemark.country, placemark.administrativeArea, placemark.subAdministrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare]
            
            let address = placemarkAttributes.compactMap { attribute in
                return attribute
            }.joined(separator: "")
            
            let newSpot = Spot(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, date: newLocation.timestamp, address: address)
            do {
                try SpotsStorage.shared.saveSpotOnDisk(newSpot)
            }catch let error{
                print(String(describing: error))
            }
            
            print("You are at \(address)")
        }
    }
}
