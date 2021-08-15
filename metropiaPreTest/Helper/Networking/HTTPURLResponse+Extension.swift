//
//  HTTPURLResponse+Extension.swift
//  pretestForDishrank
//
//  Created by Eric Chen on 2021/5/27.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool {
        return 200...299 ~= statusCode
    }
}
