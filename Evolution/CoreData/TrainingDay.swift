//
//  TrainingDay.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 23/01/2023.
//
//

import Foundation
import CoreData

@objc(TrainingDay)
public class TrainingDay: NSManagedObject,Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingDay> {
        return NSFetchRequest<TrainingDay>(entityName: "TrainingDay")
    }

    @NSManaged public var name: String
    @NSManaged public var icone: String
    @NSManaged public var id: UUID
    @NSManaged public var active: Bool
    @NSManaged public var index: Int16
    @NSManaged public var practice: NSSet?
    @NSManaged public var backup: Backup?
    
    
    func allPractice() -> [Practice]{
        guard let practice=practice else{return []}
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        var sortedArray = practice.sortedArray(using: [sortDescriptor]) as! [Practice]
        sortedArray.removeAll(where: {$0.active == false})
        return sortedArray
    }
    func allPracticeWithHidden() -> [Practice]{
        guard let practice=practice else{return []}
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        let sortedArray = practice.sortedArray(using: [sortDescriptor]) as! [Practice]
        return sortedArray
    }
}
extension TrainingDay {

    @objc(addPracticeObject:)
    @NSManaged public func addToPractice(_ value: Practice)

    @objc(removePracticeObject:)
    @NSManaged public func removeFromPractice(_ value: Practice)

    @objc(addPractice:)
    @NSManaged public func addToPractice(_ values: NSSet)

    @objc(removePractice:)
    @NSManaged public func removeFromPractice(_ values: NSSet)

}
