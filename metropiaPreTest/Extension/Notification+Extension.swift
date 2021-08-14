//
//  Notification+Extension.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import Foundation

extension Notification.Name {
    static var signInGoogleCompleted = Notification.Name("signInGoogleCompleted")
    static var signInGoogleFail = Notification.Name("signInGoogleFail")
    static let newSpotSaved = Notification.Name("newSpotSaved")
}
