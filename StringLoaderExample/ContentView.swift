//
//  ContentView.swift
//  StringLoaderExample
//
//  Created by Finn Christoffer Kurniawan on 18/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var dbTime: Double = 0.0
    @State private var nativeTime: Double = 0.0
    @State private var stringsToShow: [String] = []
    @State private var isShowingDatabaseContent = false
    let dbHelper = DatabaseManager()

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    loadStringsFromDatabase()
                }) {
                    Text("Load from Database")
                }
                .padding()
                .foregroundColor(.red)


                Button(action: {
                    loadStringsFromNative()
                }) {
                    Text("Load from Native")
                }
                .padding()
                .foregroundColor(.blue)
            }

            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(stringsToShow.indices, id: \.self) { index in
                        Text(stringsToShow[index])
                            .padding(.vertical, 4)
                    }
                }
                .padding()
            }
            .frame(maxHeight: .infinity)

            Text("Database Time: \(String(format: "%.2f ms", dbTime * 1000))")
                .padding(.top, 8)

            Text("Native Time: \(String(format: "%.2f ms", nativeTime * 1000))")
                .padding(.bottom, 8)
        }
        .onAppear {
            dbHelper.dropTable()
            for i in 1...150 {
                dbHelper.initializeDatabase(index: i)
            }
        }
    }

    private func loadStringsFromDatabase() {
        let startTime = CFAbsoluteTimeGetCurrent()
        var loadedStrings: [String] = []
        for i in 1...150 {
            if let value = dbHelper.getValueForId(i) {
                loadedStrings.append("Database \(value)")
            }
        }
        stringsToShow = loadedStrings
        dbTime = CFAbsoluteTimeGetCurrent() - startTime
        isShowingDatabaseContent = true
    }

    private func loadStringsFromNative() {
        let startTime = CFAbsoluteTimeGetCurrent()
        var loadedStrings: [String] = []
        for i in 1...150 {
            let key = "dummy_string_\(i)"
            let string = "Native \(NSLocalizedString(key, comment: ""))"
            loadedStrings.append(string)
        }
        stringsToShow = loadedStrings
        nativeTime = CFAbsoluteTimeGetCurrent() - startTime
        isShowingDatabaseContent = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
