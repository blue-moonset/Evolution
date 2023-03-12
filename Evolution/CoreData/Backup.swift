//
//  Backup+CoreDataProperties.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//
//

import Foundation
import CoreData

@objc(Backup)
public class Backup: NSManagedObject,Identifiable{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Backup> {
        return NSFetchRequest<Backup>(entityName: "Backup")
    }
    @NSManaged public var date: Date
    @NSManaged public var activity: NSSet?
    @NSManaged public var settings: Settings?
    @NSManaged public var trainingDay: NSSet?
    @NSManaged public var workInHome: NSSet?

}

// MARK: Generated accessors for activity
extension Backup {

    @objc(addActivityObject:)
    @NSManaged public func addToActivity(_ value: Activity)

    @objc(removeActivityObject:)
    @NSManaged public func removeFromActivity(_ value: Activity)

    @objc(addActivity:)
    @NSManaged public func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged public func removeFromActivity(_ values: NSSet)

    func allActivity() -> [Activity]{
        guard let activity=activity else{return []}
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortedArray = activity.sortedArray(using: [sortDescriptor]) as! [Activity]
        return sortedArray
    }
}
// MARK: Generated accessors for trainingDay
extension Backup {

    @objc(addTrainingDayObject:)
    @NSManaged public func addToTrainingDay(_ value: TrainingDay)

    @objc(removeTrainingDayObject:)
    @NSManaged public func removeFromTrainingDay(_ value: TrainingDay)

    @objc(addTrainingDay:)
    @NSManaged public func addToTrainingDay(_ values: NSSet)

    @objc(removeTrainingDay:)
    @NSManaged public func removeFromTrainingDay(_ values: NSSet)
    
    func allTrainingDay() -> [TrainingDay]{
        guard let trainingDay=trainingDay else{return []}
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        var sortedArray = trainingDay.sortedArray(using: [sortDescriptor]) as! [TrainingDay]
        sortedArray.removeAll(where: {$0.name == "gibjug-8fizxo-byJvov-archive"})
        return sortedArray
    }
    func getArchive() -> [TrainingDay]{
        guard let trainingDay=trainingDay else{return []}
        var sortedArray = trainingDay.sortedArray(using: []) as! [TrainingDay]
        sortedArray.removeAll(where: { $0.name != "gibjug-8fizxo-byJvov-archive"})
        return sortedArray
    }
}


// MARK: Generated accessors for workInHome
extension Backup {

    @objc(addWorkInHomeObject:)
    @NSManaged public func addToWorkInHome(_ value: WorkInHome)

    @objc(removeWorkInHomeObject:)
    @NSManaged public func removeFromWorkInHome(_ value: WorkInHome)

    @objc(addWorkInHome:)
    @NSManaged public func addToWorkInHome(_ values: NSSet)

    @objc(removeWorkInHome:)
    @NSManaged public func removeFromWorkInHome(_ values: NSSet)

    func allWorkInHome() -> [WorkInHome]{
        guard let workInHome=workInHome else{return []}
        let sortedArray = workInHome.sortedArray(using: []) as! [WorkInHome]
        return sortedArray
    }
}
