//
//  AreaRequest.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/15.
//

import Foundation
struct AreaRequest {
    var areaID: String
    private init(areaID: String){
        self.areaID = areaID
    }
}
extension AreaRequest {
    static func queryAreaBound(areaID: String) -> AreaRequest {
        return AreaRequest(areaID: areaID)
    }
}
