//
//  ObjectID+CoreDataClass.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 14/03/2023.
//
//

import Foundation
import CoreData

@objc(ObjectID)
public class ObjectID: NSManagedObject,Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObjectID> {
        return NSFetchRequest<ObjectID>(entityName: "ObjectID")
    }

    @NSManaged public var id: UUID
    @NSManaged public var activityWithTrainingDay: Activity?
    @NSManaged public var activityWithWorkInHome: Activity?
}
