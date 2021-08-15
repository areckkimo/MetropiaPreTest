//
//  UIImage+Extension.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/15.
//

import UIKit

extension UIImage {
    convenience init?(URL: URL) {
        guard let data = try? Data(contentsOf: URL) else{
            return nil
        }
        self.init(data:data)
    }
}
