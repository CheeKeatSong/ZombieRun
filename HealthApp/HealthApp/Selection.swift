//
//  Selection.swift
//  HealthApp
//
//  Created by Edwin Cheong on 24/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import ObjectMapper

class Selection: Mappable {
    dynamic var objectID:String?
    var missionID: Int64?
    dynamic var missonTitle:String?
    dynamic var missionBanner:String?
    dynamic var missionObjective:String?
    dynamic var missionChallenge:String?
    dynamic var missionDistance:String?
    dynamic var missionExp:String?
    dynamic var missionMoney:String?
    dynamic var missionTime:String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    init() {}
    
    init(missionID:Int64, missionTitle:String, missionBanner:String, missionObjective:String,missionChallenge:String, missionDistance:String,objectID:String,missionExp:String, missionMoney:String,missionTime:String) {
        self.missionID = missionID
        self.missonTitle = missionTitle
        self.missionBanner = missionBanner
        self.missionObjective = missionObjective
        self.missionChallenge  = missionChallenge
        self.missionDistance = missionDistance
        self.objectID = objectID
        self.missionExp = missionExp
        self.missionMoney = missionMoney
        self.missionTime = missionTime
    }
    
    func mapping(map: Map) {
        objectID <- map["objectId"]
        missonTitle <- map["MissionName"]
        missionBanner <- map["MissionBanner"]
        missionObjective <- map["MissionObjective"]
        missionChallenge <- map["MissionChallenge"]
        missionDistance <- map["MissionDistance"]
        missionExp <- map["MissionExp"]
        missionMoney <- map["MissionMoney"]
        missionTime <- map["MissionTime"]
    }
}
