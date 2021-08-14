//
//  DataResponseError.swift
//  PhotoDownload
//
//  Created by Eric Chen on 2020/3/25.
//  Copyright © 2020 Eric Chen. All rights reserved.
//
import Foundation

enum DataResponseError: Error {
    case network
    case decoding
    case missingData
    
    var description: String {
        switch self {
        case .network:
            return "An error occured while fetching data."
        case .decoding:
            return "An error occured while decoding."
        case .missingData:
            return "An error occured while missing data"
        }
    }
}
