//
//  PracticeForLiveActivity.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 20/02/2023.
//

import Foundation

public struct PracticeForLiveActivity: Codable,Hashable {

    public var repetitions: String
    public var name: String
    public var repos: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(repetitions)
        hasher.combine(name)
        hasher.combine(repos)
    }
    
    public static func == (lhs: PracticeForLiveActivity, rhs: PracticeForLiveActivity) -> Bool {
        return lhs.repetitions == rhs.repetitions &&
            lhs.name == rhs.name && lhs.repos == rhs.repos
    }
}
public struct AttributesForWatchConvert {

    public var timer:ClosedRange<Date>?
    public var isOn: Bool
    public var totalAccumulatedTime:Double
    public var practices:[PracticeForWatch]
    public var index: Int
    
    public var id=UUID()
}
public struct AttributesForWatchToIOS {

    public var timer:ClosedRange<Date>?
    public var isOn: Bool
    public var totalAccumulatedTime:Double
    public var index: Int
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        if timer != nil{
            dict["startTimer"] = dateToString(timer!.lowerBound)
            dict["endTimer"] = dateToString(timer!.upperBound)
        }
        dict["index"] = index
        dict["totalAccumulatedTime"] = totalAccumulatedTime
        dict["isOn"] = isOn
        return dict
    }
    
}
public struct AttributesForWatch {

    public var timer:ClosedRange<Date>?
    public var isOn: Bool
    public var totalAccumulatedTime:Double
    public var practices:[String:[String: Any]] 
    public var index: Int
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        if timer != nil{
            dict["startTimer"] = dateToString(timer!.lowerBound)
            dict["endTimer"] = dateToString(timer!.upperBound)
        }
        dict["index"] = index
        dict["totalAccumulatedTime"] = totalAccumulatedTime
        dict["isOn"] = isOn
        dict["practices"] = practices
        return dict
    }
    
}
public struct PracticeForWatch {

    public var repetitions: String
    public var name: String
    public var done: Bool
    public var repos: Int
    public var id : UUID
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["repetitions"] = repetitions
        dict["name"] = name
        dict["done"] = done
        dict["repos"] = repos
        dict["id"] = id.uuidString
        return dict
    }
    
}
public func dateToString(_ date: Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
}
public func stringToDate(_ string:String)->Date?{
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.date(from: string)!
}
public func convertPractice(_ practice:[Practice])->[String:[String: Any]] {
    var dic=[String:[String: Any]]()
    for (index,practice) in Array(practice.enumerated()) {
        dic["\(index)"]=PracticeForWatch(repetitions: practice.convertRepetitionToString(), name: practice.name, done: practice.done, repos: Int(practice.repos), id: practice.id).toDictionary()
    }
    return dic
}

