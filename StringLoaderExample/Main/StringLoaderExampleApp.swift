//
//  StringLoaderExampleApp.swift
//  StringLoaderExample
//
//  Created by Rizky Mashudi on 16/06/24.
//

import SwiftUI

@main
struct StringLoaderExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            StringLoaderView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            ContentView()
        }
    }
}
