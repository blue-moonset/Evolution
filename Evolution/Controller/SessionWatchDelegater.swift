//
//  SessionWatchDelegater.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 20/02/2023.
//

import Foundation
import Combine
import WatchConnectivity

class SessionWatchDelegater: NSObject, WCSessionDelegate {
    let countSubject: PassthroughSubject<AttributesForWatchConvert?, Never>
    var timerState:TimerState = .shared
    init(countSubject: PassthroughSubject<AttributesForWatchConvert?, Never>) {
        self.countSubject = countSubject
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
     
        session.activate()
        session.delegate = self
    }
    func session(_ session: WCSession, didReceiveMessage from: [String: Any]) {
        DispatchQueue.main.async {
            if let iOS = from["iOS"] as? [String: Any]{
                if let isOn = iOS["isOn"] as? Int,
                   let totalAccumulatedTime = iOS["totalAccumulatedTime"] as? Double,
                   let index = iOS["index"] as? Int,
                   let practices = iOS["practices"] as? [String: [String: Any]]{
                    
                    var sportPracticeForWatch=[SportPracticeForWatch]()
                    for i in 0...practices.count-1{
                        if let item = practices["\(i)"],
                           let title = item["title"] as? String,
                           let repetitions = item["repetitions"] as? String,
                           let done = item["done"] as? Int,
                           let repos = item["repos"] as? Int,
                           let idString = item["id"] as? String,
                           let id=UUID(uuidString: idString){
                            let doneValue=(done==0 ? false:true)
                            sportPracticeForWatch.append(SportPracticeForWatch(repetitions: repetitions, title: title, done: doneValue, repos: repos, id: id))
                        }
                    }
                    
                    let isOnValue=(isOn==0 ? false:true)
                    var timer: ClosedRange<Date>?
                    if let startTimeString = iOS["startTimer"] as? String,
                       let endTimeString = iOS["endTimer"] as? String{
                        let startDate = stringToDate(startTimeString)
                        let endDate = stringToDate(endTimeString)
                        timer = startDate!...endDate!
                    }
                    
                    let sportPractice = AttributesForWatchConvert(timer: timer, isOn: isOnValue,totalAccumulatedTime: totalAccumulatedTime, practices: sportPracticeForWatch,index: index)
                    self.countSubject.send(sportPractice)
                    
                } else {
                    print("There was an error")
                }
            }else if let watchOS = from["watchOS"] as? [String: Any]{
                if let done=watchOS["done"] as? [String]{
                    self.timerState.practicesDone=done.map({UUID(uuidString: $0)!})
                }else if let isOn = watchOS["isOn"] as? Int,
                   let totalAccumulatedTime = watchOS["totalAccumulatedTime"] as? Double,
                   let index = watchOS["index"] as? Int{
                    
                    
                    let isOnValue=(isOn==0 ? false:true)
                    self.timerState.isOn=isOnValue
                    if self.timerState.timerState != nil{
                        self.timerState.timerState!.index=index
                    }
                    
                    var timer: ClosedRange<Date>?
                    if let startTimeString = watchOS["startTimer"] as? String,
                       let endTimeString = watchOS["endTimer"] as? String{
                        let startDate = stringToDate(startTimeString)
                        let endDate = stringToDate(endTimeString)
                        timer = startDate!...endDate!
                    }
                    self.timerState.timer=timer
                    self.timerState.totalAccumulatedTime=totalAccumulatedTime
                 
                } else {
                    print("There was an error")
                }
            }else{
                print("There was an error with device")
            }
        }
    }
    #if os(iOS)
    func sessionReachabilityDidChange(_ session: WCSession){
        if session.isReachable{
            DispatchQueue.main.async {
                self.timerState.sendWatchIsReachable=true
            }
        }
    }
    #endif
    // iOS Protocol comformance
    // Not needed for this demo otherwise
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive")
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        print("sessionDidDeactivate")
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("sessionWatchStateDidChange")
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
    
    
}
