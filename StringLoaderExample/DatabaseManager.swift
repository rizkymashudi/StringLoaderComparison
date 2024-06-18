//
//  DatabaseManager.swift
//  StringLoaderExample
//
//  Created by Finn Christoffer Kurniawan on 18/06/24.
//

import SQLite3
import Foundation

class DatabaseManager {
    var db: OpaquePointer?

    init() {
        if let fileURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("strings.db") {
            if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
                print("Successfully opened connection to database.")
            } else {
                print("Unable to open database.")
            }
        }
    }

    deinit {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database.")
        }
    }
    
    func dropTable() {
        let dropTableSQL = "DROP TABLE IF EXISTS strings;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, dropTableSQL, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Table dropped successfully.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error dropping table: \(errmsg)")
            }
            sqlite3_finalize(stmt)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing drop table statement: \(errmsg)")
        }
    }


    func initializeDatabase(index: Int) {
        var stmt: OpaquePointer?

        let createTableQuery = "CREATE TABLE IF NOT EXISTS strings (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT);"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating table: \(errmsg)")
            return
        }

        let insertSQL = "INSERT INTO strings (value) VALUES (?);"
        if sqlite3_prepare_v2(db, insertSQL, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil)
            
                let value = "Dummy String \(index)"
                sqlite3_bind_text(stmt, 1, (value as NSString).utf8String, -1, nil)
                
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
                    print("Error inserting row: \(errmsg)")
                }
                
                sqlite3_reset(stmt)
            
            sqlite3_exec(db, "COMMIT", nil, nil, nil)
            sqlite3_finalize(stmt)
            
            printTableContents()
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert statement: \(errmsg)")
        }
    }
    
    func printTableContents() {
        let querySQL = "SELECT id, value FROM strings;"
        var queryStmt: OpaquePointer?

        if sqlite3_prepare_v2(db, querySQL, -1, &queryStmt, nil) == SQLITE_OK {
            print("\nTable Contents:")
            while sqlite3_step(queryStmt) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStmt, 0)
                let value = String(cString: sqlite3_column_text(queryStmt, 1))
                print("ID: \(id), Value: \(value)")
            }
            sqlite3_finalize(queryStmt)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select statement: \(errmsg)")
        }
    }
    
    func getValueForId(_ id: Int) -> String? {
        var queryStmt: OpaquePointer?
        let querySQL = "SELECT value FROM strings WHERE id = ?;"
        var value: String?

        if sqlite3_prepare_v2(db, querySQL, -1, &queryStmt, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStmt, 1, Int32(id))
            
            if sqlite3_step(queryStmt) == SQLITE_ROW {
                value = String(cString: sqlite3_column_text(queryStmt, 0))
            } else {
                print("No data found for ID: \(id)")
            }
            
            sqlite3_finalize(queryStmt)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select statement: \(errmsg)")
        }
        return value
    }


    func loadStringFromDatabase(id: Int) -> String? {
        let key = "dummy_string_\(id)"
        let querySQL = "SELECT value FROM strings WHERE key = ?;"
        var queryStmt: OpaquePointer?
        var result: String?

        if sqlite3_prepare_v2(db, querySQL, -1, &queryStmt, nil) == SQLITE_OK {
//            sqlite3_bind_text(queryStmt, 1, key, -1, nil)
            if sqlite3_step(queryStmt) == SQLITE_ROW {
                print("DEBUG Query index: \(id)")
                if let queryResultCol1 = sqlite3_column_text(queryStmt, 1) {
                    result = String(cString: queryResultCol1)
                    print("DEBUG String Result: \(result)")
                }
            } else {
                print("Query returned no results.")
            }
            sqlite3_finalize(queryStmt)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing select statement: \(errmsg)")
        }

        return result
    }
}
