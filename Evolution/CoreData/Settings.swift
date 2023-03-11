//
//  Settings+CoreDataClass.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 11/03/2023.
//
//

import Foundation
import CoreData

@objc(Settings)
public class Settings: NSManagedObject,Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var firstDay: Date?
    @NSManaged public var homePointsGo: Int16
    @NSManaged public var homePointsNone: Int16
    @NSManaged public var clubPointsGo: Int16
    @NSManaged public var clubPointsNone: Int16
    @NSManaged public var dayLastDeleteDone: Date?
    @NSManaged public var register: Bool
    
}
