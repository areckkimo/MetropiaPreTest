//
//  MapViewController.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import UIKit
import CoreLocation
import GoogleMaps
import GoogleSignIn

class MapViewController: UIViewController {
    
    // MARK: - Property
    var lastLocation: CLLocation?
    let geoCoder = CLGeocoder()
    var markers = [GMSMarker]()
    var areViewModel: AreaViewModel?
    
    lazy var locationManager: CLLocationManager = {
        let _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        _locationManager.activityType = .fitness
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    lazy var mapView: GMSMapView = {
        let defaultCamera = GMSCameraPosition(latitude: 25.036785868034467, longitude: 121.56471143616491, zoom: 15.0)
        let _mapView = GMSMapView.map(withFrame: self.view.frame, camera: defaultCamera)
        return _mapView
    }()
    
    var infoWindowView = InfoWindowView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google Map
        self.view.addSubview(mapView)
        mapView.delegate = self
        restoreMarkers()

        //Core Location
        locationManager.requestWhenInUseAuthorization()
        
        //取得Taipei圖資
        let requet = AreaRequest.queryAreaBound(areaID: "23238645")
        areViewModel = AreaViewModel(request: requet, delegate: self)
        areViewModel?.fetchAreaBound()
        
        //Info Window View
        infoWindowView.isHidden = true
        view.addSubview(infoWindowView)
        inforWindowSteupLayout()
    }
    
    // MARK: - Google Map
    func restoreMarkers(){
        let spots = SpotsStorage.shared.spots
        for spot in spots{
            let marker = GMSMarker(position: spot.coordinates)
            marker.appearAnimation = .pop
            marker.map = mapView
            marker.userData = spot
            markers.append(marker)
        }
    }
    func drawPolygonWith(coordinates: [CLLocationCoordinate2D]){
        let rect = GMSMutablePath()
        for coordinate in coordinates {
            rect.add(coordinate)
        }
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.05)
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
    }
    
    //MARK: - Others
    func inforWindowSteupLayout(){
        infoWindowView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            infoWindowView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoWindowView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            infoWindowView.heightAnchor.constraint(equalToConstant: 150),
            infoWindowView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    func springAnimation(with view: UIView){
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: .curveEaseIn) {
            view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else{
            return
        }
        guard let lastLocation = self.lastLocation else{
            self.lastLocation = newLocation
            saveNewLocation(newLocation) { (spot) in
                self.createMarkerWith(spot)
            }
            //move to current location
            mapView.animate(toLocation: newLocation.coordinate)
            
            return
        }
        if newLocation.timestamp - lastLocation.timestamp >= 60 {
            self.lastLocation = newLocation
            saveNewLocation(newLocation) { (spot) in
                self.createMarkerWith(spot)
            }
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
    
    func saveNewLocation(_ newLocation: CLLocation, completiongHandler: @escaping (Spot)->Void) {
        
        newLocation.reverseGeocoding { (address) in
            
            print("You are at \(address ?? "座標轉譯地址失敗")")
            
            let newSpot = Spot(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, date: newLocation.timestamp, address: address ?? "座標轉譯地址失敗")
            
            do {
                try SpotsStorage.shared.saveSpotOnDisk(newSpot)
                completiongHandler(newSpot)
            }catch let error{
                print("[Saving new location is fail: \(error.localizedDescription)]")
            }
            
        }
    }
    
    func createMarkerWith(_ spot: Spot){
        DispatchQueue.main.async {
            if self.markers.count == 10 {
                //remove the oldeset marker
                let theOldestMarker = self.markers[0]
                theOldestMarker.map = nil
                self.markers.removeFirst()
            }
            let marker = GMSMarker(position: spot.coordinates)
            marker.appearAnimation = .pop
            marker.map = self.mapView
            marker.userData = spot
            self.markers.append(marker)
        }
    }
}
//MARK: - AreaViewModelDelegate
extension MapViewController: AreaViewModelDelegate{
    func onFetchCompleted() {
        guard let coordinates = areViewModel?.coordinates else {
            return
        }
        drawPolygonWith(coordinates: coordinates)
    }
    
    func onFetchFailed(error: HTTPError) {
        print(error.description)
    }
}
//MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print((marker.userData as? Spot)?.address ?? "")
        if let spot = marker.userData as? Spot {
            infoWindowView.timeLable.text = spot.dateString
            infoWindowView.timeLable.sizeToFit()
            infoWindowView.addressLable.text = spot.address
            infoWindowView.addressLable.sizeToFit()
            if let avatarImageURL = GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: UInt(infoWindowView.avatarImageView.frame.width * UIScreen.main.scale)){
                infoWindowView.avatarImageView.image = UIImage(URL: avatarImageURL)
            }
        }
        
        infoWindowView.isHidden = false
        springAnimation(with: infoWindowView)
        
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate.latitude)
        infoWindowView.isHidden = true
    }
}
