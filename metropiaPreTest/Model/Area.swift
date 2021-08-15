//
//  Area.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/15.
//

import Foundation

struct Area: Decodable {
    let features: [Feature]
    struct Feature: Decodable {
        let geometry: Geometry
    }
    struct Geometry: Decodable {
        let coordinates: [[[Double]]]
    }
}
