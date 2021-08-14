//
//  SpotsStorage.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import Foundation

import CoreLocation

class SpotsStorage {
    static let shared = SpotsStorage()
    private let documentsURL: URL?
    private(set) var spots: [Spot]
    
    init() {
        let fileManager = FileManager.default
        documentsURL = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        guard let documentsURL = documentsURL,
              let spotFilesURLs = try? fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else {
            spots = []
            return
        }
        let jsonDecoder = JSONDecoder()
        let _spots = spotFilesURLs.compactMap { (url) -> Spot? in
            guard let data = try? Data(contentsOf: url) else {
                return nil
            }
            return try? jsonDecoder.decode(Spot.self, from: data)
        }.sorted(by: {$0.date > $1.date}).prefix(10)
        spots = Array(_spots)
    }
    
    func saveSpotOnDisk(_ spot: Spot) throws {
        
        let timestamp = spot.date.timeIntervalSince1970
        guard let fileURL = documentsURL?.appendingPathComponent("\(timestamp)") else {
            return
        }
        let encoder = JSONEncoder()
        let data = try encoder.encode(spot)
        try data.write(to: fileURL)
        
        spots.insert(spot, at: 0)
        if spots.count > 10 {
            spots.removeLast()
        }
        
        NotificationCenter.default.post(name: .newSpotSaved, object: self, userInfo: ["spot": spot])
    }
}
