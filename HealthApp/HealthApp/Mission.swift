//
//  Mission.swift
//  HealthApp
//
//  Created by Edwin Cheong on 25/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import ObjectMapper

class Mission: Mappable {
    var offset: Int?
    var data: [Selection]?
    var totalObjects: Int?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        offset <- map["offset"]
        data <- map["data"]
        totalObjects <- map["totalObjects"]
    }
}
