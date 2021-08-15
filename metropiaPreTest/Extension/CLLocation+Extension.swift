//
//  CLLocation+Extension.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/15.
//

import Foundation
import CoreLocation

extension CLLocation{
    func reverseGeocoding(completionHandle: @escaping (String?)->Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self) { (placemarks, error) in
            guard error == nil, let placemark = placemarks?.first else{
                completionHandle(nil)
                return
            }
            
            let placemarkAttributes = [placemark.country, placemark.administrativeArea, placemark.subAdministrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare]
            
            let address = placemarkAttributes.compactMap { attribute in
                return attribute
            }.joined(separator: "")
            
            completionHandle(address)
        }
    }
}
