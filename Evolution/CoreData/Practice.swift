//
//  Practice+CoreDataProperties.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/01/2023.
//
//

import Foundation
import CoreData
@objc(Practice)
public class Practice: NSManagedObject,Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Practice> {
        return NSFetchRequest<Practice>(entityName: "Practice")
    }
    
    @NSManaged public var active: Bool
    @NSManaged public var done: Bool
    @NSManaged public var id: UUID
    @NSManaged public var index: Int16
    @NSManaged public var lien: String?
    @NSManaged public var name: String
    @NSManaged public var repetitionInsteadMinute: Bool
    @NSManaged public var repos: Int16
    @NSManaged public var numberRepetitions: Int16
    @NSManaged public var lengthRepetition: Int16
    @NSManaged public var maxLengthRepetition: Int16
    @NSManaged public var trainingDay: TrainingDay?
    
    func convertRepetitionToString()-> String{
        let repetitions="\(numberRepetitions) x \(repetitionInsteadMinute ? "\(lengthRepetition)": Int(lengthRepetition).convertSecondsToMinutes())\(maxLengthRepetition==0 ? "":" / \(repetitionInsteadMinute ? "\(maxLengthRepetition)": Int(maxLengthRepetition).convertSecondsToMinutes())")"
        return repetitions
    }
    func convertRepetitionToStringWithWord()-> String{
        let repetitions="\(numberRepetitions) x \(repetitionInsteadMinute ? "\(lengthRepetition)": Int(lengthRepetition).convertSecondsToMinutes())\(maxLengthRepetition==0 ? "":" / \(repetitionInsteadMinute ? "\(maxLengthRepetition)": Int(maxLengthRepetition).convertSecondsToMinutes())")"
        let type=(repetitionInsteadMinute ? "répétition\(lengthRepetition==1 ? "":"s")":"")
        return repetitions+" "+type
    }
}
