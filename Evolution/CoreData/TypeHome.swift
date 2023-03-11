//
//  TypeHome+CoreDataProperties.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/11/2022.
//
//

import Foundation
import CoreData

@objc(TypeHome)
public class TypeHome: NSManagedObject,Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TypeHome> {
        return NSFetchRequest<TypeHome>(entityName: "TypeHome")
    }

    @NSManaged public var abdo: Bool
    @NSManaged public var pompe: Bool
    @NSManaged public var day: Day
}
