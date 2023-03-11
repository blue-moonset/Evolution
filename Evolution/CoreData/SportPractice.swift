//
//  SportPractice+CoreDataProperties.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/01/2023.
//
//

import Foundation
import CoreData
@objc(SportPractice)
public class SportPractice: NSManagedObject,Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SportPractice> {
        return NSFetchRequest<SportPractice>(entityName: "SportPractice")
    }

    @NSManaged public var id: UUID
    @NSManaged public var lien: String?
    @NSManaged public var repetitions: String?
    @NSManaged public var repos: Int16
    @NSManaged public var title: String
    @NSManaged public var index: Int16
    @NSManaged public var done: Bool
    @NSManaged public var active: Bool
    @NSManaged public var typeDay: TypeDay
}
