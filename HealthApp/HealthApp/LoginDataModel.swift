//
//  LoginDataModel.swift
//  HealthApp
//
//  Created by Edwin Cheong on 14/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginDataModel: Mappable {
    
    dynamic var objectID: String!
    dynamic var profilePic:String!
    dynamic var userName:String!
    dynamic var userToken:String!
    dynamic var email:String!
    var userExp: Int64!
    var userLevel:Int64!
    var userMoney:Int64!
    var userTotalDistance:Double!
    var userBaseLevel:Int64!
    var userZombieNumber:Int64!
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        objectID <- map["objectId"]
        profilePic <- map["profilePic"]
        userName <- map["name"]
        userToken <- map["user-token"]
        email <- map["email"]
        userExp <- map["UserExp"]
        userLevel <- map["UserLevel"]
        userMoney <- map["UserMoney"]
        userTotalDistance <- map["UserTotalDistance"]
        userBaseLevel <- map["UserBaseLevel"]
        userZombieNumber <- map["UserZombieNumber"]
    }
}
