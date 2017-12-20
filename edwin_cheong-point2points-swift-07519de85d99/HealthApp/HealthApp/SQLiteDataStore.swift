
//
//  SQLiteDataStore.swift
//  HealthApp
//
//  Created by Edwin Cheong on 14/03/2017.
//  Copyright © 2017 Point2Points. All rights reserved.
//

import UIKit
import SQLite
import Foundation

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() -> Void
    static func insert(item:T) -> Void
    static func delete() -> Void
    static func update(item:T) -> Void
    static func find() -> T
    static func findAll() -> [T]
}

enum SQLERROR: Error {
    case FoundNil(String)
}

class SQLiteDataStore: NSObject {
    static let sharedInstance = SQLiteDataStore()
    
    override init() {
    }
    
    func createDB() -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let db = try! Connection("\(path)/db.sqlite3")
        return db
    }
    
    func createTable() {
        LoginCRUDHelper.createTable()
        MissonCRUDHelper.createTable()
    }

    static func makeDB() {
        let sql = SQLiteDataStore()
        if Utilities.isObjectNil(object: sql.createDB()) {
            print("Not empty")
        }
        
        sql.createTable()
    }
}
