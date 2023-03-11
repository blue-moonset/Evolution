//
//  LiveActivityHelper.swift
//  PracticeActivityExtension
//
//  Created by Samy Tahri-Dupre on 19/02/2023.
//

import Foundation
import Foundation
import ActivityKit
import SwiftUI
import WidgetKit



//public func convertPractices(practices:[SportPractice])->[SportPracticeForLiveActivity]{
//    var array=[SportPracticeForLiveActivity]()
//    for practice in practices {
//        let item=SportPracticeForLiveActivity(repetitions: practice.repetitions ?? "", title: practice.title, repos: Int(practice.repos))
//        array.append(item)
//    }
//    return array
//}
//public class LiveActivityHelper {
//    static let shared = LiveActivityHelper()
//    var practiceActivity: Activity<PracticeActivityAttributes>?
//    var timerState:TimerState = .shared
//    
//    func start(timer:ClosedRange<Date>) {
//        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
//        
//        let initialContentState = PracticeActivityAttributes.ContentState(time: timer,pauseTime: nil,isOn: true,index: timerState.timerState!.index, practices: convertPractices(practices: timerState.timerState!.practices))
//        let activityAttributes = PracticeActivityAttributes()
//        
//        let activityContent = ActivityContent(state: initialContentState, staleDate: Calendar.current.date(byAdding: .minute, value: 20, to: Date())!)
//        
//        do {
//            practiceActivity = try Activity<PracticeActivityAttributes>.request(
//            attributes: activityAttributes,
//            content: activityContent)
//            guard practiceActivity != nil else {
//                print("Error: Could not initialize activity.")
//                return
//              }
//            print("good")
//        } catch (let error) {
//          print("Error: \(error.localizedDescription)")
//        }
//    }
//    func update(timer:ClosedRange<Date>,void:LinkActivity) {
//        if void == .play{
//            let newContentState = PracticeActivityAttributes.ContentState(time: timer,pauseTime: nil,isOn: true,index: timerState.timerState!.index, practices: convertPractices(practices: timerState.timerState!.practices))
//            Task {
//                guard let practiceActivity else { return }
//                await practiceActivity.update(using: newContentState,alertConfiguration:nil)
//            }
//        }else if void == .pause || void == .reset || void == .last || void == .next{
//            let practice=timerState.timerState!.practices[timerState.timerState!.index]
//            let pauseTime=Int(Double(practice.repos)-timerState.totalAccumulatedTime)
//            let newContentState = PracticeActivityAttributes.ContentState(time: timer,pauseTime: pauseTime,isOn: false,index: timerState.timerState!.index, practices: convertPractices(practices: timerState.timerState!.practices))
//            Task {
//                guard let practiceActivity else { return }
//                await practiceActivity.update(using: newContentState,alertConfiguration:nil)
//                print("top")
//            }
//        }
////        TODO: udate data when change
//    }
//    func end() {
//        let finalContentState = PracticeActivityAttributes.ContentState(time: Date.now...Date(),pauseTime: nil, isOn: false,index: timerState.timerState!.index, practices: convertPractices(practices: timerState.timerState!.practices))
//        let finalContent = ActivityContent(state: finalContentState, staleDate: nil)
//        
//        Task {
//            guard let practiceActivity else { return }
//            await practiceActivity.end(finalContent, dismissalPolicy: .immediate)
//        }
//    }
//    func removeAll() {
//        guard timerState.timerState != nil else { return }
//        let finalContentState = PracticeActivityAttributes.ContentState(time: Date.now...Date(),pauseTime: nil, isOn: false,index: timerState.timerState!.index, practices: convertPractices(practices: timerState.timerState!.practices))
//        let finalContent = ActivityContent(state: finalContentState, staleDate: nil)
//        Task{
//            for activity in Activity<PracticeActivityAttributes>.activities {
//                await activity.end(finalContent, dismissalPolicy: .immediate)
//            }
//        }
//    }
//}
