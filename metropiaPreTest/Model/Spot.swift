//
//  Spot.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import Foundation
import CoreData

struct Spot: Codable {
    var latitude: Double
    var longitude: Double
    var date: Date
    var address: String
}

extension Spot {
    var coordinates:  CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
