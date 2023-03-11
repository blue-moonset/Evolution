//
//  Day+CoreDataProperties.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/11/2022.
//
//

import Foundation
import CoreData


@objc(Day)
public class Day: NSManagedObject,Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }
    
    @NSManaged public var clubRepos: Bool
    @NSManaged public var club: Bool
    @NSManaged public var dateOfDay: Date
    @NSManaged public var home: Bool
    @NSManaged public var typeHome: TypeHome
    @NSManaged public var idTypeDay: [UUID]
}
