//
//  WorkInHome+CoreDataClass.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 16/03/2023.
//
//

import Foundation
import CoreData

@objc(WorkInHome)
public class WorkInHome: NSManagedObject,Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkInHome> {
        return NSFetchRequest<WorkInHome>(entityName: "WorkInHome")
    }

    @NSManaged public var name: String
    @NSManaged public var id: UUID
    @NSManaged public var active: Bool
    @NSManaged public var backup: Backup?

}
