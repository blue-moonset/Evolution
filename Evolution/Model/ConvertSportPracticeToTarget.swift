//
//  SportPracticeForLiveActivity.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 20/02/2023.
//

import Foundation

public struct SportPracticeForLiveActivity: Codable,Hashable {

    public var repetitions: String
    public var title: String
    public var repos: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(repetitions)
        hasher.combine(title)
        hasher.combine(repos)
    }
    
    public static func == (lhs: SportPracticeForLiveActivity, rhs: SportPracticeForLiveActivity) -> Bool {
        return lhs.repetitions == rhs.repetitions &&
            lhs.title == rhs.title && lhs.repos == rhs.repos
    }
}
public struct AttributesForWatchConvert {

    public var timer:ClosedRange<Date>?
    public var isOn: Bool
    public var totalAccumulatedTime:Double
    public var practices:[SportPracticeForWatch]
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
public struct SportPracticeForWatch {

    public var repetitions: String
    public var title: String
    public var done: Bool
    public var repos: Int
    public var id : UUID
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["repetitions"] = repetitions
        dict["title"] = title
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
public func convertSportPractice(_ sportPractice:[SportPractice])->[String:[String: Any]] {
    var dic=[String:[String: Any]]()
    for (index,practice) in Array(sportPractice.enumerated()) {
        dic["\(index)"]=SportPracticeForWatch(repetitions: practice.repetitions ?? "", title: practice.title, done: practice.done, repos: Int(practice.repos), id: practice.id).toDictionary()
    }
    return dic
}
