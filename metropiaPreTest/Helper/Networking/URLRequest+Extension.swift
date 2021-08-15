//
//  URLRequest+Extension.swift
//  pretestForDishrank
//
//  Created by Eric Chen on 2021/5/27.
//

import Foundation

extension URLRequest {
    func queryDataAdapter(data: [String: String]) -> URLRequest {
        var request = self
        guard let url = request.url else {
            return self
        }
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            return self
        }
        urlComponents.queryItems = data.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        request.url = urlComponents.url
        return request
    }
}
