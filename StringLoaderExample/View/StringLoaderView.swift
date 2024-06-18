//
//  StringLoaderView.swift
//  StringLoaderExample
//
//  Created by Rizky Mashudi on 16/06/24.
//

import SwiftUI

struct StringLoaderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var loadTime: Double = 0.0
    @State private var strings: [String] = []
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Local String Loader")
                .font(.largeTitle)
            
            List {
                ForEach(strings, id: \.self) { text in
                    Text(text)
                }
            }
            .listStyle(.inset)
            
            Text("Load Time: \(loadTime, specifier: "%.4f") seconds")
                .font(.footnote)
            
            VStack {
                Button(action: {
                    let startTime = Date()
                    loadStringsFromJSON()
                    let endTime = Date()
                    loadTime = endTime.timeIntervalSince(startTime)
                    
                }, label: {
                    Text("Load string resource from json")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                })
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
                
                Button(action: {
                    let startTime = Date()
                    loadStringsFromCoreData()
                    let endTime = Date()
                    loadTime = endTime.timeIntervalSince(startTime)
                    
                }, label: {
                    Text("Load string resource from core data")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                })
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green, lineWidth: 1.0)
                )
                .padding(.horizontal)
            }
        }
        .onAppear{
            loadStringsFromJSONAndSaveToCoreData()
        }
    }
    
    private func loadStringsFromJSON() {
        strings = []
        
        if let url = Bundle.main.url(forResource: "localstring", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedResource = try JSONDecoder().decode(StringResource.self, from: data)
                strings = decodedResource.strings
            } catch {
                print("Failed to load JSON: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadStringsFromJSONAndSaveToCoreData() {
        if let url = Bundle.main.url(forResource: "localstring", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedResource = try JSONDecoder().decode(StringResource.self, from: data)
                saveStringsToCoreData(strings: decodedResource.strings)
            } catch {
                print("Failed to load JSON: \(error.localizedDescription)")
            }
        }
    }

    private func loadStringsFromCoreData() {
        strings = []
        
        let fetchRequest = AppStringLocalEntity.fetchRequest()
        do {
            let results = try viewContext.fetch(fetchRequest)
            strings = results.compactMap { $0.stringItem }
        } catch {
            print("Failed to fetch from Core Data: \(error.localizedDescription)")
        }
    }
    
    private func saveStringsToCoreData(strings: [String]) {
        let fetchRequest = AppStringLocalEntity.fetchRequest()
        
        do {
            let existingStrings = try viewContext.fetch(fetchRequest).compactMap { $0.stringItem }
            let newStrings = strings.filter { !existingStrings.contains($0) }
            
            viewContext.perform {
                for string in strings {
                    let newEntity = AppStringLocalEntity(context: viewContext)
                    newEntity.stringItem = string
                }
                do {
                    try viewContext.save()
                } catch {
                    print("Failed to save to Core Data: \(error.localizedDescription)")
                }
            }
            
        } catch {
            print("Failed to fetch from Core Data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    StringLoaderView()
}
