//
//  Activity+CoreDataProperties.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/11/2022.
//
//

import Foundation
import CoreData


@objc(Activity)
public class Activity: NSManagedObject,Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }
    
    @NSManaged public var clubRepos: Bool
    @NSManaged public var club: Bool
    @NSManaged public var date: Date
    @NSManaged public var home: Bool
    @NSManaged public var backup: Backup?
    @NSManaged public var idTrainingDay: NSSet?
    @NSManaged public var idWorkInHome: NSSet?

}

// MARK: Generated accessors for idTrainingDay
extension Activity {

    @objc(addIdTrainingDayObject:)
    @NSManaged public func addToIdTrainingDay(_ value: ObjectID)

    @objc(removeIdTrainingDayObject:)
    @NSManaged public func removeFromIdTrainingDay(_ value: ObjectID)

    @objc(addIdTrainingDay:)
    @NSManaged public func addToIdTrainingDay(_ values: NSSet)

    @objc(removeIdTrainingDay:)
    @NSManaged public func removeFromIdTrainingDay(_ values: NSSet)
    
    func allIdTrainingDay() -> [ObjectID]{
        guard let idTrainingDay=idTrainingDay else{return []}
        let sortedArray = idTrainingDay.sortedArray(using: []) as! [ObjectID]
        return sortedArray
    }

}
// MARK: Generated accessors for idWorkInHome
extension Activity {

    @objc(addIdWorkInHomeObject:)
    @NSManaged public func addToIdWorkInHome(_ value: ObjectID)

    @objc(removeIdWorkInHomeObject:)
    @NSManaged public func removeFromIdWorkInHome(_ value: ObjectID)

    @objc(addIdWorkInHome:)
    @NSManaged public func addToIdWorkInHome(_ values: NSSet)

    @objc(removeIdWorkInHome:)
    @NSManaged public func removeFromIdWorkInHome(_ values: NSSet)

    func allIdWorkInHome() -> [ObjectID]{
        guard let idWorkInHome=idWorkInHome else{return []}
        let sortedArray = idWorkInHome.sortedArray(using: []) as! [ObjectID]
        return sortedArray
    }
}
