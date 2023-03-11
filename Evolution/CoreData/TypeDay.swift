//
//  TypeDay.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 23/01/2023.
//
//

import Foundation
import CoreData

@objc(TypeDay)
public class TypeDay: NSManagedObject,Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TypeDay> {
        return NSFetchRequest<TypeDay>(entityName: "TypeDay")
    }

    @NSManaged public var name: String
    @NSManaged public var icone: String
    @NSManaged public var id: UUID
    @NSManaged public var active: Bool
    @NSManaged public var index: Int16
    @NSManaged public var sportPractice: NSSet?
    
    
    func allSportPractice() -> [SportPractice]{
        guard let sportPractice=sportPractice else{return []}
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        let sortedArray = sportPractice.sortedArray(using: [sortDescriptor]) as! [SportPractice]
        return sortedArray
    }
}
extension TypeDay {

    @objc(addSportPracticeObject:)
    @NSManaged public func addToSportPractice(_ value: SportPractice)

    @objc(removeSportPracticeObject:)
    @NSManaged public func removeFromSportPractice(_ value: SportPractice)

    @objc(addSportPractice:)
    @NSManaged public func addToSportPractice(_ values: NSSet)

    @objc(removeSportPractice:)
    @NSManaged public func removeFromSportPractice(_ values: NSSet)

}
