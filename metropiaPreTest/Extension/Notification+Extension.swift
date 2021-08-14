//
//  Notification+Extension.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import Foundation

extension Notification.Name {
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: "signInGoogleCompleted")
    }
    static var signInGoogleFail: Notification.Name {
        return .init(rawValue: "signInGoogleFail")
    }
}
