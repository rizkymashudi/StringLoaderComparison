//
//  AppStringLocalEntity+CoreDataProperties.swift
//  StringLoaderExample
//
//  Created by Rizky Mashudi on 16/06/24.
//
//

import Foundation
import CoreData


extension AppStringLocalEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppStringLocalEntity> {
        return NSFetchRequest<AppStringLocalEntity>(entityName: "AppStringLocalEntity")
    }

    @NSManaged public var stringItem: String?

}

extension AppStringLocalEntity : Identifiable {

}
