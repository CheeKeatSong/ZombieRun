//
//  LoginCRUDHelper.swift
//  HealthApp
//
//  Created by Edwin Cheong on 14/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import SQLite

class LoginCRUDHelper: DataHelperProtocol {
    static let TABLE_NAME = "Users"
    
    //Table data name
    static let userID = Expression<Int64>("userID")
    static let objectID = Expression<String>("objectID")
    static let profilePic = Expression<String>("profilePic")
    static let userName = Expression<String>("name")
    static let email = Expression<String>("email")
    static let userToken = Expression<String>("user-token")
    static let userExp = Expression<Int64>("userExp")
    static let userLevel = Expression<Int64>("userLevel")
    static let userMoney = Expression<Int64>("userMoney")
    static let userTotalDistance = Expression<Double>("userTotalDistance")
    static let userBaseLevel = Expression<Int64>("userBaseLevel")
    static let userZombieNumber = Expression<Int64>("userZombieNumber")
    
    static let db = SQLiteDataStore()
    static let users = Table(TABLE_NAME)
    
    typealias T = LoginDataModel
    
    static func createTable() {
        do {
            try db.createDB().run(users.create(ifNotExists: true){ table in
                table.column(userID, primaryKey: .autoincrement)
                table.column(objectID)
                table.column(email,unique:false)
                table.column(profilePic)
                table.column(userToken,unique:true)
                table.column(userName)
                table.column(userExp)
                table.column(userLevel)
                table.column(userMoney)
                table.column(userTotalDistance)
                table.column(userBaseLevel)
                table.column(userZombieNumber)
            })
        } catch let error as NSError {
            print("Table creation error \(error)")
        }
    }
    
    static func insert(item: LoginDataModel) -> Void {
        if Utilities.isObjectNil(object: item) == true {
            
            //Delete old stuff first
            delete()
            
            //Only then insert
            do {
                try db.createDB().run(users.insert(
                    userName <- item.userName,
                    objectID <- item.objectID,
                    profilePic <- item.profilePic,
                    email <- item.email,
                    userToken <- item.userToken,
                    userExp <- item.userExp,
                    userLevel <- item.userLevel,
                    userMoney <- item.userMoney,
                    userTotalDistance <- item.userTotalDistance,
                    userBaseLevel <- item.userBaseLevel,
                    userZombieNumber <- item.userZombieNumber
                ))
                
            } catch let error as NSError  {
                print("Insertion failed: \(error)")
            }
        } else {
            print("Item is empty!")
        }
        
    }
    
    static func delete() {
        do {
            try db.createDB().run(users.delete())
        } catch let error as NSError {
            print("Delete failed: \(error)")
        }
    }
    
    static func update(item: LoginDataModel) {
        if Utilities.isObjectNil(object: item) != false {
            do {
                let results = try! db.createDB().run(users.update(
                    userName <- item.userName,
                    objectID <- item.objectID,
                    profilePic <- item.profilePic,
                    email <- item.email,
                    userToken <- item.userToken,
                    userExp <- item.userExp,
                    userLevel <- item.userLevel,
                    userMoney <- item.userMoney,
                    userTotalDistance <- item.userTotalDistance,
                    userBaseLevel <- item.userBaseLevel,
                    userZombieNumber <- item.userZombieNumber

                ))
                
                guard results == 0 else {
                    throw SQLERROR.FoundNil("Fail to Update")
                }
            } catch {
                print("Update failed: \(error)")
            }
            
        } else {
            print("Empty object")
        }
        
    }
    
    internal static func find() -> LoginDataModel {
        let results = LoginDataModel()
        do {
            for user in try db.createDB().prepare(users) {
                results.userName = user[userName]
                results.email = user[email]
                results.objectID = user[objectID]
                results.profilePic = user[profilePic]
                results.userToken = user[userToken]
                results.userExp = user[userExp]
                results.userLevel = user[userLevel]
                results.userMoney = user[userMoney]
                results.userTotalDistance = user[userTotalDistance]
                results.userBaseLevel = user[userBaseLevel]
                results.userZombieNumber = user[userZombieNumber]
            }
        } catch let error as NSError {
            print("Select failed : \(error)")
        }
        
        return results
    }
    
    static func getToken() -> String {
        let results = LoginDataModel()
        do {
            for user in try db.createDB().prepare(users) {
                results.userToken = user[userToken]
            }
        } catch let error as NSError {
            print("No token available : \(error)")
        }
        
        return results.userToken != nil ? results.userToken : ""
    }
    
    
    static func findAll() -> [LoginDataModel] {
        let retArray = [T]()
        return retArray
    }
}
