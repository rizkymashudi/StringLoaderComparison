//
//  DatabaseManager.swift
//  StringLoaderExample
//
//  Created by Rizky Mashudi on 16/06/24.
//

import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db: Connection?
    private let stringsTable = Table("strings")
    private let id = Expression<Int64>("id")
    private let content = Expression<String>("content")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            db = try Connection("\(path)/db.sqlite3")
            createTable()
        } catch {
            db = nil
            print("Unable to open database. Verify that you created the directory described in the Getting Started section.")
        }
    }
    
    private func createTable() {
        do {
            try db?.run(stringsTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(content)
            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func insertDummyStrings() {
        do {
            try db?.run(stringsTable.delete()) // Clear existing entries
            for i in 1...150 {
                try db?.run(stringsTable.insert(content <- "Dummy String \(i)"))
            }
        } catch {
            print("Unable to insert dummy strings")
        }
    }
    
    //TODO: Improve the query using code snippet from PoC.md
    func getAllStrings() -> [String] {
        var strings = [String]()
        do {
            for string in try db!.prepare(stringsTable) {
                strings.append(string[content])
            }
        } catch {
            print("Unable to fetch strings")
        }
        return strings
    }
}
