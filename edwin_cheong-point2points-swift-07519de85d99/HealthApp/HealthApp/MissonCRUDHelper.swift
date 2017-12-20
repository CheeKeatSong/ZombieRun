//
//  MissonCRUDHelper.swift
//  HealthApp
//
//  Created by Edwin Cheong on 25/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import SQLite

class MissonCRUDHelper: DataHelperProtocol {
    static let TABLE_NAME = "Mission"
    
    //Table data name
    static let missionID = Expression<Int64>("missionID")
    static let missionTitle = Expression<String>("missionTitle")
    static let missionIcon = Expression<String>("missionIcon")
    static let missionBanner = Expression<String>("missionBanner")
    static let missionObjective = Expression<String>("missionObjective")
    static let missionChallenge = Expression<String>("missionChallenge")
    static let missionDistance = Expression<String>("missionDistance")
    static let missionExp = Expression<String>("missionExp")
    static let missionMoney = Expression<String>("missionMoney")
    static let missionTime = Expression<String>("missionTime")
    static let objectID = Expression<String>("ObjectID")
    
    static let db = SQLiteDataStore()
    static let mission = Table(TABLE_NAME)
    
    typealias T = Selection
    
    static func createTable() {
        do {
            try db.createDB().run(mission.create(ifNotExists: true){ table in
                table.column(missionID, primaryKey: .autoincrement)
                table.column(missionTitle,unique:false)
                table.column(missionObjective)
                table.column(missionChallenge,unique:false)
                //	table.column(missionIcon)
                table.column(missionBanner)
                table.column(missionDistance)
                table.column(missionExp)
                table.column(missionMoney)
                table.column(missionTime)
                table.column(objectID)
            })
        } catch let error as NSError {
            print("Table creation error \(error)")
        }
    }
    
    static func insert(item: Selection) {
        if Utilities.isObjectNil(object: item) == true {
            
            //Delete old stuff first
            delete()
            
            //Only then insert
            do {
                try db.createDB().run(mission.insert(
                    missionTitle  <-  item.missonTitle!,
                    //missionIcon <- item.missionIcon!,
                    missionBanner <- item.missionBanner!,
                    missionObjective <- item.missionObjective!,
                    missionChallenge <- item.missionChallenge!,
                    missionDistance <- item.missionDistance!,
                    missionExp <- item.missionExp!,
                    missionMoney <- item.missionMoney!,
                    missionTime <- item.missionTime!,
                    objectID <- item.objectID!
                ))
                
            } catch let error as NSError  {
                print("Insertion failed: \(error)")
            }
        } else {
            print("Item is empty!")
        }
    }
    
    static func bulkInsert(item: [Selection]) {
        if Utilities.isObjectNil(object: item as AnyObject!) != false {
            //Delete old entry to insert new one
            delete()
            
            do {
                for index in 0..<item.count {
                    try db.createDB().run(mission.insert(
                        missionTitle  <-  item[index].missonTitle!,
                        //missionIcon <- item[index].missionIcon!,
                        missionBanner <- item[index].missionBanner!,
                        missionObjective <- item[index].missionObjective!,
                        missionChallenge <- item[index].missionChallenge!,
                        missionDistance <- item[index].missionDistance!,
                        missionExp <- item[index].missionExp!,
                        missionMoney <- item[index].missionMoney!,
                        missionTime <- item[index].missionTime!,
                        objectID <- item[index].objectID!
                    ))
                }
            } catch let error as NSError {
                print("Bulk Insertion failed: \(error)")
            }
        }
    }
    
    static func delete() {
        do {
            try db.createDB().run(mission.delete())
        } catch let error as NSError {
            print("Delete failed: \(error)")
        }
    }
    
    static func find() -> Selection {
        let selection = Selection()
        
        return selection
    }
    
    static func update(item: Selection) {
        
    }
    
    static func findAll() -> [Selection] {
        var retArray = [T]()
        
        do {
            for item in try db.createDB().prepare(mission) {
                retArray.append(
                    Selection(
                        missionID: item[missionID],
                        missionTitle: item[missionTitle],
                        //missionIcon: item[missionIcon],
                        missionBanner: item[missionBanner],
                        missionObjective: item[missionObjective],
                        missionChallenge: item[missionChallenge],
                        missionDistance: item[missionDistance],
                        objectID: item[objectID],
                        missionExp: item[missionExp],
                        missionMoney: item[missionMoney],
                        missionTime: item[missionTime]
                    )
                )
            }
        } catch let error as NSError {
            print("Delete failed: \(error)")
        }
        
        
        return retArray
    }
}
