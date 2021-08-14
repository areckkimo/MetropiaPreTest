//
//  Date+Extension.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/14.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
