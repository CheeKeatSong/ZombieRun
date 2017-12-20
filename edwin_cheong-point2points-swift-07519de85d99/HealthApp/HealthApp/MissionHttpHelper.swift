//
//  MissionHttpHelper.swift
//  HealthApp
//
//  Created by Edwin Cheong on 26/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class MissionHttpHelper: NSObject {
    static let baseLink = "http://api.backendless.com/v1/data/MissionSelection"
    
    static func getMissions() {
        Alamofire.request(baseLink, method: .get, encoding: JSONEncoding.default, headers: RegHttpHelper.headers).responseJSON { response in //get error
            switch response.result {
            case .success(let data):
                print(data)
                let jsonData = Mapper<Mission>().map(JSONObject: data)
                if Utilities.isObjectNil(object: jsonData as AnyObject!) != false {
                    MissonCRUDHelper.bulkInsert(item: (jsonData?.data)!)
                } else {
                    print("JSON Object is nil")
                }
                
                
            case .failure(let error):
                //Error report
                print("Request failed with error:\n " + String(describing: error))
                
            }
        }

    }
}
