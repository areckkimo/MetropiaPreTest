//
//  HTTPError.swift
//  pretestForDishrank
//
//  Created by Eric Chen on 2021/5/27.
//

import Foundation

enum HTTPError: Error {
    case noData
    case noHttpResponse
    case invalidURL
    case requestFail
    case httpResponseFail
    case jsonDecodingFail
    
    var description: String {
        switch self {
        case .noData:
            return "HTTP request doesn't response any data"
        case .noHttpResponse:
            return "HTTP request's response is nil"
        case .invalidURL:
            return "The URL is invalid."
        case .requestFail:
            return "HTTP request was failure"
        case .httpResponseFail:
            return "HTTP response status code is not between 200 and 299"
        case .jsonDecodingFail:
            return "JSON String convert to specify object was failure."
        }
    }
}
